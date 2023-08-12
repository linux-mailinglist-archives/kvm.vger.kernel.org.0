Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1077A421
	for <lists+kvm@lfdr.de>; Sun, 13 Aug 2023 01:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjHLXEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Aug 2023 19:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjHLXEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Aug 2023 19:04:11 -0400
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D183E4D
        for <kvm@vger.kernel.org>; Sat, 12 Aug 2023 16:04:14 -0700 (PDT)
X-AuthUser: ybhuang@cs.utexas.edu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1691881453;
        bh=MHfEc4t6xiVtil6mBdRdw/TSYxc7mzdJimjJ+uN1Tx8=;
        h=From:Subject:Date:To:From;
        b=OOHIGLLnsv7G2AS1vDAvorJpGk9JWtGZ8WMek4c/fcZXjMSYrelQyQDOsZP09A51c
         MGMXd8qjDIROAEQ3eO1TRlLpMiTKOZ2ckb+u1cxQ+7NBxzZdTs8lx9kJZRJT3FhN56
         ZJYQT0jb4hMkGTi04eozeZUe4u1bzHUr1qm/MNfw=
Received: from smtpclient.apple (035-146-022-132.res.spectrum.com [35.146.22.132])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 37CN4CfU006623
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Sat, 12 Aug 2023 18:04:13 -0500
From:   Yibo Huang <ybhuang@cs.utexas.edu>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.3\))
Subject: A question about how the KVM emulates the effect of guest MTRRs on
 AMD platforms
Message-Id: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
Date:   Sat, 12 Aug 2023 18:04:12 -0500
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3696.120.41.1.3)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Sat, 12 Aug 2023 18:04:13 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi the KVM community,

I am sending this email to ask about how the KVM emulates the effect of =
guest MTRRs on AMD platforms.

Since there is no hardware support for guest MTRRs, the VMM can simulate =
their effect by altering the memory types in the EPT/NPT. =46rom my =
understanding, this is exactly what the KVM does for Intel platforms. =
More specifically, in arch/x86/kvm/mmu/spte.c #make_spte(), the KVM =
tries to respect the guest MTRRs by calling #kvm_x86_ops.get_mt_mask() =
to get the memory types indicated by the guest MTRRs and applying that =
to the EPT. For Intel platforms, the implementation of =
#kvm_x86_ops.get_mt_mask() is #vmx_get_mt_mask(), which calls the =
#kvm_mtrr_get_guest_memory_type() to get the memory types indicated by =
the guest MTRRs.

However, on AMD platforms, the KVM does not implement =
#kvm_x86_ops.get_mt_mask() at all, so it just returns zero. Does it mean =
that the KVM does not use the NPT to emulate the effect of guest MTRRs =
on AMD platforms? I tried but failed to find out how the KVM does for =
AMD platforms.

Can someone help me understand how the KVM emulates the effect of guest =
MTRRs on AMD platforms? Thanks a lot!

Best,
Yibo=
