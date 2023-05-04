Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44CB6F731E
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 21:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjEDTQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 15:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjEDTQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 15:16:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929517ECB
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 12:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683227736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eu4smx04I1AOShAcSlKxzRKnKb94GOmquYwLELDKb4c=;
        b=Dcb3Cfc7OkQU98kDRhu6vaYDvf8bOBr/BDGaryuiN5QYwqyOJEGFqn+jvxwF7HlRa73j7A
        G2QPTi/YcGW7QijLxeHM/p2kBd9Lu3KrsDlztzq3Fz3nmg0WYu5z7329adb8G+9fpkrlc3
        /i9xBI8XII4rp2J3gNgNijqO0zMlXxE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-7_VA9uN9Ne-4l_ask89zog-1; Thu, 04 May 2023 15:09:32 -0400
X-MC-Unique: 7_VA9uN9Ne-4l_ask89zog-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ed767b30easo1341991cf.1
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 12:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683227367; x=1685819367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eu4smx04I1AOShAcSlKxzRKnKb94GOmquYwLELDKb4c=;
        b=jxBYkkUdy4griZwlS+U6Y6PkrvgV8ftxxnFXiaPbVUyhpWHm27pKcrjupqTfazhfIN
         nA+PokSeW7cXQRJCYw3gl/XMtfj4Q6e4dvs+kOi1QYW7n100hV+PPIodfCmalL4nGQZw
         M9XhPNAu67UK+eeqBAbhvy+bH2ced4tIROTK1a6oSXtOy+Q76Jc8bK8ukA0WYyCqrZI3
         35s+TpF36wSp78tZwh/PrNflVay6Papog23P6QjQ25nCHb7akcpBL3o6fd6iBAd6zbtH
         j5zrTwvPU05lSMlIBvuKgBLxsXPom/uy1JqdR1TZ5sWNMe7vFfx7xYCtv+wvHveUl8rC
         iWGA==
X-Gm-Message-State: AC+VfDyKHMlSamySnq39ppIx+90kxMHvlKl+WhMIDhQ10O7B9QcJs5SP
        3jl8xQxLH0RS0sUxxVe97EhozvlPKORIZyLzzUR1WdYvH6cSEJ3EnI4pTod5RdIOa+TfcFz5eh2
        UQyI/lbq6rMMo
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr16093001qtc.1.1683227367529;
        Thu, 04 May 2023 12:09:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QNqm7XccS4dHnALMbPxn5A0zXinogoQpNb6AmeNNL6KcjUqhZFOjqDRxXi8Tuj51+zuEF2Q==
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr16092953qtc.1.1683227367219;
        Thu, 04 May 2023 12:09:27 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id i3-20020a37c203000000b0074e0e6aae1csm12050qkm.36.2023.05.04.12.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 12:09:26 -0700 (PDT)
Date:   Thu, 4 May 2023 15:09:25 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFQC5TZ9tVSvxFWt@x1n>
References: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZFLyGDoXHQrN1CCD@x1n>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 07:45:28PM -0400, Peter Xu wrote:
> On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
> > On Wed, May 03, 2023, Peter Xu wrote:
> > > Oops, bounced back from the list..
> > > 
> > > Forward with no attachment this time - I assume the information is still
> > > enough in the paragraphs even without the flamegraphs.
> > 
> > The flamegraphs are definitely useful beyond what is captured here.  Not sure
> > how to get them accepted on the list though.
> 
> Trying again with google drive:
> 
> single uffd:
> https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view
> 
> 32 uffds:
> https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view
> 
> > 
> > > > From what I got there, vmx_vcpu_load() gets more highlights than the
> > > > spinlocks. I think that's the tlb flush broadcast.
> > 
> > No, it's KVM dealing with the vCPU being migrated to a different pCPU.  The
> > smp_call_function_single() that shows up is from loaded_vmcs_clear() and is
> > triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU (yay for the
> > VMCS caches not being coherent).
> > 
> > Task migration can also trigger IBPB (if mitigations are enabled), and also does
> > an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
> > 
> > Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ eliminate the
> > vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely represenative of a real
> > world configuration.
> 
> Yes it does went away:
> 
> https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view
> 
> With pinning vcpu threads only (again, over 40 hard cores/threads):
> 
> ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
> 
> It seems to me for some reason the scheduler ate more than I expected..
> Maybe tomorrow I can try two more things:
> 
>   - Do cpu isolations, and
>   - pin reader threads too (or just leave the readers on housekeeping cores)

I gave it a shot by isolating 32 cores and split into two groups, 16 for
uffd threads and 16 for vcpu threads.  I got similiar results and I don't
see much changed.

I think it's possible it's just reaching the limit of my host since it only
got 40 cores anyway.  Throughput never hits over 350K faults/sec overall.

I assume this might not be the case for Anish if he has a much larger host.
So we can have similar test carried out and see how that goes.  I think the
idea is making sure vcpu load overhead during sched-in is ruled out, then
see whether it can keep scaling with more cores.

-- 
Peter Xu

