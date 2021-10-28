Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7E743E1BA
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ1NNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhJ1NNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 09:13:50 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7265BC061570;
        Thu, 28 Oct 2021 06:11:23 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id f10so2249719ilu.5;
        Thu, 28 Oct 2021 06:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1sv2pVjuobpaTD6e7jjCzSJYHPbS/EWvyrW59yWrJP4=;
        b=kGeEAnH2GZMfu36XdYP0RYPN3EHxgor/2x4oBQFh8bL0W+rn1CsbXgt6zE7DULl6V5
         4RvPh9qjgTQLYEem/svKD3wQRNU4wHQTDr7DS79PGD2pSTtUpBqrAo4EKuYtD7zhUozi
         cWo+s5fDFhaRwaMUFycNjhkXrW5rsf17GzsmgJ+VgmMbXCTHk+3Rc7cd7yd5FSDsG9ue
         ay1RDoZeUHinplF7rKnlp7MiFWKMVCZP+cZtl67mDJjapDQgJ7DAmeGUB+aQjSUrK12u
         NT5qf7hEMODgbPIK2sgB8w7lSwJn9Jn/jNpen9bz825uBYG9hTv30iyKHM2IerPgdh1Q
         qVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1sv2pVjuobpaTD6e7jjCzSJYHPbS/EWvyrW59yWrJP4=;
        b=jfz3A2ZsYYKMgZIdz4Coeqmirs3Ca0xWe4T2VLTLzFDsHhgXwU8E8NltAJNMftK8sW
         akqfb5cohsRXqun1PMygMqCidWOUDM6XUfzgY8yYYzYW3stpkXC9qWxEL6OCxgUHZEao
         22yIeFjjhBupKQnTG1/gY3jqC8BYZ3bFEGSukhdRr02Tfxln1QALz3auO0FeDk0xZysK
         +9BvSVuemqoTa58HDPTkhXZhnjU9hUng5b4MhUIpIsn57grxHI54wSTgAtXlZO8mMCoY
         jyvsvnI2ALDsKRhbHuxIp8JW8VIxKquyaU5aB/AvhFwQl+w5QBNtISn+3VlvFMkDvml9
         XKwA==
X-Gm-Message-State: AOAM532bcntxR9TWLchdMlz63vXkyMr98IR6BfwLmyZ0cnlxkRZhgcFi
        AbkcMq9pSA0FvP86ARK6FpLKPFGVuwW8+qpYw+CSsPYIkVg=
X-Google-Smtp-Source: ABdhPJz7vI5nHIlFyRgGSpaq+jCGnJTbs4wpK50NHm0c4jUfi0BQOrUqDOa59ndDyLUF6VuTlx6uYvTGfaBN1jblSKI=
X-Received: by 2002:a05:6e02:893:: with SMTP id z19mr3129606ils.224.1635426682913;
 Thu, 28 Oct 2021 06:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-24-sean.j.christopherson@intel.com>
In-Reply-To: <20200320212833.3507-24-sean.j.christopherson@intel.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Thu, 28 Oct 2021 21:11:11 +0800
Message-ID: <CAJhGHyD=S6pVB+OxM7zF0_6LnMUCLqyTfMK4x9GZsdRHZmgN7Q@mail.gmail.com>
Subject: Re: [PATCH v3 23/37] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 5:29 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> +       if (!nested_cpu_has_vpid(vmcs12) || !nested_has_guest_tlb_tag(vcpu)) {
> +               kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +       } else if (is_vmenter &&
> +                  vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> +               vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> +               vpid_sync_context(nested_get_vpid02(vcpu));
> +       }
> +}


(I'm sorry to pick this old email to reply to, but the problem has
nothing to do with this patch nor 5c614b3583e7 and it exists since
nested vmx is introduced.)

I think kvm_mmu_free_guest_mode_roots() should be called
if (!enable_ept && vmcs12->virtual_processor_id != vmx->nested.last_vpid)
just because prev_roots doesn't cache the vpid12.
(prev_roots caches PCID, which is distinctive)

The problem hardly exists if L1's hypervisor is also kvm, but if
L1's hypervisor is different or is also kvm with some changes
in the way how it manages VPID.  (Actually, I planned to
change the way how it manages VPID to svm-like.)

nvcpu0 and nvcpu1 are in the same nested VM and are running the same
application process.

vcpu1: runs nvcpu1 with the same cr3 as nvcpu0
vcpu0: runs nvcpu0, modifies pagetable and L1 sync root, and flush VPID12
       but L0 doesn't sync, it just removes the root from vcpu0's prev_roots.
vcpu1: L1 migrates nvcpu0 to here, allocates a *fresh* VPID12 to nvcpu0
       like the ways svm allocates a fresh ASID.
vcpu1: runs nvcpu0 without any flush. (vcpu1's prev_roots has already had it
       L0 hasn't synced it)

If my understanding is correct, I hope it is a report and somebody fixes it.
