Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAEF6F6234
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjECXqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjECXqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFBC10EF
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683157535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMaKw+IppdV4cHhReakXaZPqqwThQZcij9BRR4m2CeA=;
        b=DPvWbGp7dUdv52sb2VNKqRfnMnBKG+8A8P20+qn6mkMc1C/y9acBuvhq9aByvI/vKOWmzM
        071hVyysaUXNuUMcVOBo2MqbtQQHjoBuGL1cfev72VgCQH4OVPNbPKiKruKmr4NSApGcwz
        XyYXDIKM9ndfmYNFEsO/nxIBNVx/kAY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-UjAELSn6PBCERtPp2_dtXw-1; Wed, 03 May 2023 19:45:34 -0400
X-MC-Unique: UjAELSn6PBCERtPp2_dtXw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-5ef67855124so9453106d6.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 16:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683157531; x=1685749531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BMaKw+IppdV4cHhReakXaZPqqwThQZcij9BRR4m2CeA=;
        b=O4eRAOqcZo9xHna/jyiFkeKAuZdsDq1DFPgJj1FIXNohoRfXQKOVm1WPWVHH4vnz29
         QciJSRWaZfeeDPJJgU+01NXS8q0aon7pdG2PHrWl7Fzx8evPUhPGBfhxcHmgwFz+cpCH
         Tk7ENtVQ0FMd4wsH28PSJqDDy0GIi6Spx47Dnqs/5Co9YxKq/tWQ9uXiM8dO+dW+N5/7
         JrU6O8q4zc7Hc5Ex7KvOnEbSAkw8OgtKn9bbZreUmO/4vV/vz/W9hPrmq44Z4cLO3znf
         LEqKEmny+Tj4om5u+3EZI9BozNt9TgkDPNawHrpBVELd8LZ36fQClZN9xrZT5M4zzAIh
         Knng==
X-Gm-Message-State: AC+VfDy8ky7CPI6KLYQ4h31+YSutG+VGG94DZSlThIRcshvp2MP4y6tq
        cg+9OqiUzXZMDNKftXKZSEvfXwDfsE5n4n5vHajFmDOjfqTf5fFaG2stB/U0Vg+Xk/DWPtP/2ut
        IM9MYSOaSx/bJ
X-Received: by 2002:a05:6214:4111:b0:61b:9e0f:9398 with SMTP id kc17-20020a056214411100b0061b9e0f9398mr1699818qvb.5.1683157531193;
        Wed, 03 May 2023 16:45:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4JTxs6jVg6TlbxOKspmgRaahwdFBNfWZjzFxJhtQsbdgr1QwXuBM2wDKtRzzjKkbggRojs5w==
X-Received: by 2002:a05:6214:4111:b0:61b:9e0f:9398 with SMTP id kc17-20020a056214411100b0061b9e0f9398mr1699802qvb.5.1683157530876;
        Wed, 03 May 2023 16:45:30 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id jo30-20020a056214501e00b0061693e61dbfsm4998439qvb.63.2023.05.03.16.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:45:30 -0700 (PDT)
Date:   Wed, 3 May 2023 19:45:28 -0400
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
Message-ID: <ZFLyGDoXHQrN1CCD@x1n>
References: <ZEGuogfbtxPNUq7t@x1n>
 <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZFLVS+UvpG5w747u@google.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
> On Wed, May 03, 2023, Peter Xu wrote:
> > Oops, bounced back from the list..
> > 
> > Forward with no attachment this time - I assume the information is still
> > enough in the paragraphs even without the flamegraphs.
> 
> The flamegraphs are definitely useful beyond what is captured here.  Not sure
> how to get them accepted on the list though.

Trying again with google drive:

single uffd:
https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view

32 uffds:
https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view

> 
> > > From what I got there, vmx_vcpu_load() gets more highlights than the
> > > spinlocks. I think that's the tlb flush broadcast.
> 
> No, it's KVM dealing with the vCPU being migrated to a different pCPU.  The
> smp_call_function_single() that shows up is from loaded_vmcs_clear() and is
> triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU (yay for the
> VMCS caches not being coherent).
> 
> Task migration can also trigger IBPB (if mitigations are enabled), and also does
> an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
> 
> Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ eliminate the
> vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely represenative of a real
> world configuration.

Yes it does went away:

https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view

With pinning vcpu threads only (again, over 40 hard cores/threads):

./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32

It seems to me for some reason the scheduler ate more than I expected..
Maybe tomorrow I can try two more things:

  - Do cpu isolations, and
  - pin reader threads too (or just leave the readers on housekeeping cores)

-- 
Peter Xu

