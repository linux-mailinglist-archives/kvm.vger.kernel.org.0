Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24B46B7E59
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 17:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCMQ7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 12:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCMQ66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 12:58:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761FB3BDB1
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 09:58:30 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id n33-20020a17090a5aa400b0023b4f444476so1436916pji.3
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 09:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678726709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WoW76m3bvwmTZ8xs2qkv5SM2JmnsotKY8+cFv048dbE=;
        b=pRe7H9y53cuXvdWbCUjymHm2/u+oD29ozshZ6oS3VPTm/TwCcPiHZM8yArd+tieJAL
         2yV9kHhzx2fJAbm/ofCApJJZ06DwZ7rXbVmpmwR3zkX2ItZZr4ptDezXFhDFF1bzuAxj
         urpbkQkIvy0OL0aImRhxMs9JBrHkrBQo/PgPEKsoQBAODav9gGx8hanbgoXfBSXYtIrm
         d1UT8ziS4zrwux+wClZhCv4ZHRDsD/094z8e2zOCkYQRCAbnINIK8CICKcpcLk/iOMvA
         Mk06FmaP2dxuqlC4sMCe0RJjf01az+NiX8Z+/1OFaB+yLT5x+sjYmoUSQubbiCvsXR+n
         kr5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoW76m3bvwmTZ8xs2qkv5SM2JmnsotKY8+cFv048dbE=;
        b=ayseLF488gKUHVO83eqL3TQsgtpH1rPSc8P/jNBpFki78xyxbvRik5nZEJC/wH6v1S
         +/l00OxdQ7xTMslrKdGNyhckd+BlJcLBLYg4pJHXYE4VhSvEvhc3hv/76KRc7ayfWS/J
         ggpwTVBnAKByEsFBrTHQSRnGcxnhZMib5iiExAn3EP/+EENMptNw65smjrdgkVwMmcPn
         bBELz+ltTTWz4rjypuSzEskYT1h5o1v6ITW17ZzAq7g7d22/hu0FSQVLsnrP55t8eObz
         y6p/heDjjoNX/ghiWjqLBtsTX8KhE6R/dv4EtkD8/zp5yfxvneQ8DAMvZC53sk9CkpYW
         oRNA==
X-Gm-Message-State: AO0yUKW9LRUcm5kS5VxIAdLomBsy8t451ALlwgDiXMZJh2i9kdxpfflF
        El71j8rDNlosU4rfFvQnZFaJrrmPj8A=
X-Google-Smtp-Source: AK7set/Zjdzj/4pezdtemaPeNPXkMeeoAvvxL6bSDB577mJpjxS/MFRW5Ck+bIY5nCRdoEZ8H3otcIZdQSQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7583:b0:19f:8213:ac38 with SMTP id
 j3-20020a170902758300b0019f8213ac38mr1917064pll.3.1678726709348; Mon, 13 Mar
 2023 09:58:29 -0700 (PDT)
Date:   Mon, 13 Mar 2023 09:58:27 -0700
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
Mime-Version: 1.0
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
Message-ID: <ZA9WM3xA6Qu5Q43K@google.com>
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Chen CJ <jason.cj.chen@intel.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> This patch set is part-5 of this RFC patches. It introduces VMX
> emulation for pKVM on Intel platform.
> 
> Host VM wants the capability to run its guest, it needs VMX support.

No, the host VM only needs a way to request pKVM to run a VM.  If we go down the
rabbit hole of pKVM on x86, I think we should take the red pill[*] and go all the
way down said rabbit hole by heavily paravirtualizing the KVM=>pKVM interface.

Except for VMCALL vs. VMMCALL, it should be possible to eliminate all traces of
VMX and SVM from the interface.  That means no VMCS emulation, no EPT shadowing,
etc.  As a bonus, any paravirt stuff we do for pKVM x86 would also be usable for
KVM-on-KVM nested virtualization.

E.g. an idea floating around my head is to add a paravirt paging interface for
KVM-on-KVM so that L1's (KVM-high in this RFC) doesn't need to maintain its own
TDP page tables.  I haven't pursued that idea in any real capacity since most
nested virtualization use cases for KVM involve running an older L1 kernel and/or
a non-KVM L1 hypervisor, i.e. there's no concrete use case to justify the development
and maintenance cost.  But if the PV code is "needed" by pKVM anyways...

[*] You take the blue pill, the story ends, you wake up in your bed and believe
    whatever you want to believe. You take the red pill, you stay in wonderland,
    and I show you how deep the rabbit hole goes.

    -Morpheus
