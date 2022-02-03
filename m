Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711AC4A7D35
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbiBCBFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240397AbiBCBFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:05:32 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A6CC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:05:32 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id a25so1580256lji.9
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=no98sJqFHzFBoQm6u3XZ2SQSb79IHiOJfLLDh7CV32w=;
        b=UsvEciVRnpUck8q/nF2PyFTYbV0ypGdu3GIFPUVt14KV/+xD4z4AWq0hEVy5Ug4JcV
         TqDeKJ9IUCWO2RDG08pheOTu5nkvoZ0yAzcTxYD09h0PWRhiIUqbMdZgxe1TQY2vIkCc
         zi3IJx90MothDEdNXK9EvnZGJytBS0b+cQbUvZaRDInTbR8sXDa8bs02Psq39pUmG7Gi
         k79tK5pzr517g+NkvGrEd4Fr1XoqjGQrHSv6+WKEFVUaq80wrN/VNtH5v3erSAj73D5t
         bJcnvNWwluZkft7wANhXld1+pIBvEgAoO2/GFiqvF0eY4xELzP6JYBMN91npgkQjce6g
         5Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=no98sJqFHzFBoQm6u3XZ2SQSb79IHiOJfLLDh7CV32w=;
        b=Z1gLbImQrldUjbmloTDI+zQpoFIwvHhgbWzbKrJOfd7hRUbjifGSgTSjqRJkRUD/zd
         7bLDgYWXQXbRn3L7h6cptxrbK2fNIf73LLdYPMYZAyPG/oH6zLy1S8Q9JOee9grIHRH5
         BWTKHMd9AiEtoNG6cc4g+OOB/Pg4L/CTkoHMy/LyfTjHyao/mUH94jnvHgOZQLO7WBKI
         doYVHpXi6BoEmOAIiWPiGHXhvt5TBN01eZDWEK8jQDX0v521xd6IsAMz5LbtrcL2ZKev
         O/N8ex1YHm2RYVHzNs+IqSbkFwSKm+uELfd6bMlGGv3WM1kuV96vg1OKZ1qZWg4Qfslx
         1+1w==
X-Gm-Message-State: AOAM533ZdfS4Ek2RCRKqd5n9s5+J19C2O7wj9+7jjjEiXXJoKWt0xrwo
        bmpf55/JBqJZkn712yj8bm8lRJggtdzQFmCpfymCau+1hz0=
X-Google-Smtp-Source: ABdhPJxYx6lOs67PeljqfX1t6m55BsrgYeYdJuuYmHFa9duK7++l7QSYZDHFFQZfR259PX5xM9SB2nl3L3hfyKVRI+M=
X-Received: by 2002:a2e:b449:: with SMTP id o9mr20793718ljm.140.1643850330275;
 Wed, 02 Feb 2022 17:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com> <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com> <CAOQ_Qsiv=QqKGr4H2dP30DEozzvmSpa1SLjX8T5vhSfv=gTy3g@mail.gmail.com>
 <YfsoBECWPpP0BpOW@google.com>
In-Reply-To: <YfsoBECWPpP0BpOW@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 2 Feb 2022 17:05:19 -0800
Message-ID: <CAOQ_QsgzQ+30_y6jXgiiC3k1iwKcqXk_UoSHJdzg-y7LzTj64w@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 4:55 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 02, 2022, Oliver Upton wrote:
> > On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > > MSR_IA32_FEAT_CTL has this same issue.  But that mess also highlights an issue
> > > with this series: if userspace relies on KVM to do the updates, it will break the
> > > existing ABI, e.g. I'm pretty sure older versions of QEMU rely on KVM to adjust
> > > the MSRs.
> >
> > I realize I failed to add a note about exactly this in the cover
> > letter. It seems, based on the commit 5f76f6f5ff96 ("KVM: nVMX: Do not
> > expose MPX VMX controls when guest MPX disabled") we opted to handle
> > the VMX capability MSR in-kernel rather than expecting userspace to
> > pick a sane value that matches the set CPUID. So what really has
> > become ABI here? It seems as though one could broadly state that KVM
> > owns VMX VM-{Entry,Exit} control MSRs without opt-in, or narrowly
> > assert that only the bits in this series are in fact ABI.
>
> I don't know Paolo's position, but personally I feel quite strongly that KVM should
> not manipulate the guest vCPU model.  KVM should reject changes that put the kernel
> at risk, but otherwise userspace should have full control.

Ditto, just want to make sure there's agreement that such a quirk only
applies to these bits and not the whole pile.
