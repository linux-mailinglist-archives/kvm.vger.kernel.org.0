Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AC7149C3
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 14:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjE2M6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 08:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjE2M6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 08:58:03 -0400
Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89A3BE
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 05:58:01 -0700 (PDT)
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
        by w1.tutanota.de (Postfix) with ESMTP id E62C6FBFA9E
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 12:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685365080;
        s=s1; d=tutanota.com;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
        bh=0lzY7uQh5PFwmUzkeQFV7IDV1zBE5Sk0M13m+9yxFqk=;
        b=nWPKejHzY8SuPfofUnsoA6preRJyu/tQfR9pxgWM66BawmRy2bQ/GoAOPgFgilSK
        HXXRE6E/aUnli2tSzvZzhpaT2WSIVMfltkELJAYeXA4UwEk8PWUw2Yiyir69i/Lw5nc
        j+E1fNuCITb7Wf2ZReWgoEHxPFZaRlv+0IZHT+BkuA/Wg2S6rVIq8fwm9sEv5XR1f/D
        y7mU2YLOqUMf7H27RslpqJzQyyrS/VXuW014UBdXtVhDMkUL5YdlYr1CzNWGHZNXIX4
        2W7zb9AR3CiA5LzSO7VXTQ5TZnyqFIC0JKfPTWeJx4OBklpe8a/rGNAEKgjzgmIjtqJ
        A1Xsh9+QUQ==
Date:   Mon, 29 May 2023 14:58:00 +0200 (CEST)
From:   jwarren@tutanota.com
To:     Kvm <kvm@vger.kernel.org>
Message-ID: <NWb_YOE--3-9@tutanota.com>
Subject: [Bug] AMD nested: commit broke VMware
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
Since kernel 5.16 users can't start VMware VMs when it is nested under KVM on AMD CPUs.

User reports are here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
https://forums.unraid.net/topic/128868-vmware-7x-will-not-start-any-vms-under-unraid-6110/

I've pinpointed it to commit 174a921b6975ef959dd82ee9e8844067a62e3ec1 (appeared in 5.16rc1)
"nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"

I've confirmed that VMware errors out when it checks for TLB_CONTROL_FLUSH_ASID support and gets a 'false' answer.

First revisions of the patch in question had some support for TLB_CONTROL_FLUSH_ASID, but it was removed:
https://lore.kernel.org/kvm/f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com/

I don't know what would be the best case here, maybe put a quirk there, so it doesn't break "userspace".
Committer's email is dead, so I'm writing here.
