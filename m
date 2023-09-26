Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74CA7AEC63
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 14:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbjIZMUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 08:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjIZMU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 08:20:29 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CDDEB;
        Tue, 26 Sep 2023 05:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=w0YyJiw+O+zjquHaZvxAIGS0bC7/dphOHY+erwD9474=; b=xBKqfA
        iBmX8ri+p/zTD5MvUJhspvsg3Hs9muE33AZemCF/OgeGJLZvi9ML1U4RvsEBY9RM7xyLOucvrWDhQ
        oj5yAlaUjASxZIg7BDgoxa4oPDwJ68AH9FUbz066WsiY6H7m98WmQw5e01gC5DXty9ytNgJiJFURk
        2BLX72JHWno=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql736-0000GS-Kl; Tue, 26 Sep 2023 12:20:20 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1ql736-0001mF-Cv; Tue, 26 Sep 2023 12:20:20 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>
Subject: [PATCH v6 00/11] KVM: xen: update shared_info and vcpu_info handling
Date:   Tue, 26 Sep 2023 12:20:02 +0000
Message-Id: <20230926122013.867391-1-paul@xen.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The following text from the original cover letter still serves as an
introduction to the series:

"Currently we treat the shared_info page as guest memory and the VMM
informs KVM of its location using a GFN. However it is not guest memory as
such; it's an overlay page. So we pointlessly invalidate and re-cache a
mapping to the *same page* of memory every time the guest requests that
shared_info be mapped into its address space. Let's avoid doing that by
modifying the pfncache code to allow activation using a fixed userspace HVA
as well as a GPA."

As with the previous version of the series, both the shared_info and
vcpu_info caches can now be activated using an HVA but the commit comment
on "map shared_info using HVA rather than GFN" has been extended to
explain why mapping shared_info using HVA is a particularly good idea.

This version of the series also includes an extra patch to "allow
vcpu_info content to be 'safely' copied. Currently there is a race window
when the VMM performs the copy; this patch allows the VMM to avoid that
race.

Paul Durrant (11):
  KVM: pfncache: add a map helper function
  KVM: pfncache: add a mark-dirty helper
  KVM: pfncache: add a helper to get the gpa
  KVM: pfncache: base offset check on khva rather than gpa
  KVM: pfncache: allow a cache to be activated with a fixed (userspace)
    HVA
  KVM: xen: allow shared_info to be mapped by fixed HVA
  KVM: xen: allow vcpu_info to be mapped by fixed HVA
  KVM: selftests / xen: map shared_info using HVA rather than GFN
  KVM: selftests / xen: re-map vcpu_info using HVA rather than GPA
  KVM: xen: advertize the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA capability
  KVM: xen: allow vcpu_info content to be 'safely' copied

 Documentation/virt/kvm/api.rst                |  53 +++++--
 arch/x86/kvm/x86.c                            |   5 +-
 arch/x86/kvm/xen.c                            |  92 +++++++++----
 include/linux/kvm_host.h                      |  43 ++++++
 include/linux/kvm_types.h                     |   3 +-
 include/uapi/linux/kvm.h                      |   9 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  59 ++++++--
 virt/kvm/pfncache.c                           | 129 +++++++++++++-----
 8 files changed, 302 insertions(+), 91 deletions(-)

-- 
2.39.2

