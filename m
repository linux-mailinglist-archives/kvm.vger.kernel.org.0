Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7109C596650
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 02:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbiHQAdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiHQAdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 20:33:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7378740E0E
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660696412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gu3f8Uog699HPKySkkdEJkGI/KU5n2mtK1CidLAiQ1I=;
        b=ZnEXm80Ui/M7csMFXTZaYOL3s/2znmIo46d/g5xvNZlO4viLrRGuy6o3e/ilQtSZ2ncUTu
        5ZLZIoIvwWScNsD6V0IY6l00KTBgbHCJtMbbpc48fEp5El1+t1QeUws9SR/gYFd3xHKa7o
        2gfncGBm46GpQwNGshxZw7Lo4PcOqoA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-600-f32e8My7NGSD_nrACtTeBA-1; Tue, 16 Aug 2022 20:33:31 -0400
X-MC-Unique: f32e8My7NGSD_nrACtTeBA-1
Received: by mail-qk1-f200.google.com with SMTP id f16-20020a05620a409000b006bacc0fcf23so10532729qko.13
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 17:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Gu3f8Uog699HPKySkkdEJkGI/KU5n2mtK1CidLAiQ1I=;
        b=B/7Wqjviw0cfiFwcPKOYpayD8GMPebQEMzjgYzgfav7rpyXQC6Qpj4Phmh7vyD9vPw
         kmsrD2ABEeJh2TY52ogc/BU2NXK9+WSQxzDq/f/A1RQWStcpnATxGQperfYkCoxlUPn+
         iQzqSvQt9PEHFavr9p19LCAR/PA793bMu0unvgRbV79y1SrKnXNkfNKlc+tgG/S8fH6o
         1lGYpvKpjm3oMAqQsn4f+kc4x+35Oy67JBvHsrdArFF3VgYuHfcnrpxFIJ7NSeaxuk7E
         8pI3BFke6V51fLUfE2dooga9pIHpcKZJsjOupUKDEsMWUCJdlHOSOHQ95/6SNgPXaiX3
         nlCA==
X-Gm-Message-State: ACgBeo3eniCLMJUqAzCUUMJRqAu0r71vGwQirsp49jVq4WUWnw5/ddXb
        D0qcGcASS6DVbDlxCJpq0pA/fccVvCf1aCDJtgViWVD6RbtiHyFk6swXIJFcURLxcBZSGbkZZjj
        yYeCOkcowqAX8
X-Received: by 2002:ad4:5b87:0:b0:476:c32f:f4e9 with SMTP id 7-20020ad45b87000000b00476c32ff4e9mr20327659qvp.50.1660696410707;
        Tue, 16 Aug 2022 17:33:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7hsaDXTV7yehyf9x57wNQJi2qIp6fce0pdtvbetwzxpFYY8PTY98DcketWQKuDgxU7Kpm0VQ==
X-Received: by 2002:ad4:5b87:0:b0:476:c32f:f4e9 with SMTP id 7-20020ad45b87000000b00476c32ff4e9mr20327651qvp.50.1660696410501;
        Tue, 16 Aug 2022 17:33:30 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id e3-20020ac86703000000b00341a807ed21sm11455951qtp.72.2022.08.16.17.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:33:30 -0700 (PDT)
Date:   Tue, 16 Aug 2022 20:33:28 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v2 1/3] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <Yvw3WJQhLQ0cuQ9G@xz-m1.local>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721000318.93522-2-peterx@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 08:03:16PM -0400, Peter Xu wrote:
> We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> issue with it is that not all GUP paths are able to handle signal delivers
> besides SIGKILL.
> 
> That's not ideal for the GUP users who are actually able to handle these
> cases, like KVM.
> 
> KVM uses GUP extensively on faulting guest pages, during which we've got
> existing infrastructures to retry a page fault at a later time.  Allowing
> the GUP to be interrupted by generic signals can make KVM related threads
> to be more responsive.  For examples:
> 
>   (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
>       e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
>       generated to kick the vcpus out of kernel context immediately,
> 
>   (2) SIGINT: which can be used with interactive hypervisor users to stop a
>       virtual machine with Ctrl-C without any delays/hangs,
> 
>   (3) SIGTRAP: which grants GDB capability even during page faults that are
>       stuck for a long time.
> 
> Normally hypervisor will be able to receive these signals properly, but not
> if we're stuck in a GUP for a long time for whatever reason.  It happens
> easily with a stucked postcopy migration when e.g. a network temp failure
> happens, then some vcpu threads can hang death waiting for the pages.  With
> the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> enable the ability to trap these signals.
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

Will squash the hugetlb support too altogether, which is a one-liner
anyway:

---8<---
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a57e1be41401..4025a305d573 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6176,9 +6176,12 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
                                fault_flags |= FAULT_FLAG_WRITE;
                        else if (unshare)
                                fault_flags |= FAULT_FLAG_UNSHARE;
-                       if (locked)
+                       if (locked) {
                                fault_flags |= FAULT_FLAG_ALLOW_RETRY |
                                        FAULT_FLAG_KILLABLE;
+                               if (flags & FOLL_INTERRUPTIBLE)
+                                       fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
+                       }
                        if (flags & FOLL_NOWAIT)
                                fault_flags |= FAULT_FLAG_ALLOW_RETRY |
                                        FAULT_FLAG_RETRY_NOWAIT;
---8<---

I'll still keep R-b for John and DavidH.

Thanks,

-- 
Peter Xu

