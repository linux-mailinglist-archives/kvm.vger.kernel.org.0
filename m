Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B076C47BC
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 11:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjCVKe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 06:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCVKex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 06:34:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B973A4347A
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 03:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679481246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rVkLd1gXXSaNzOK+vQH5hpvFlsKrXbqvBvpTSZkuN40=;
        b=NnLJlmfTbMW8M3xPx80bU6/PCsDO6qXHxDueRCsbRWg7kt8H0YQy7q0T0yOj8t+IFKU42k
        ANft8+5ji2w3KJmpTQBv555i2Qjlr7uUZ91Xy7GFpZsXwzV+ZCnrnrHrKeOP4Gc6fHRO4P
        +BBmkHnewKk7Evuq60ovRgPYM/3aWlE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-b5iL3yxZNV26tN2GMOdBpw-1; Wed, 22 Mar 2023 06:34:05 -0400
X-MC-Unique: b5iL3yxZNV26tN2GMOdBpw-1
Received: by mail-wm1-f72.google.com with SMTP id ay12-20020a05600c1e0c00b003ed201dcf71so8527383wmb.4
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 03:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481244;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rVkLd1gXXSaNzOK+vQH5hpvFlsKrXbqvBvpTSZkuN40=;
        b=jYt6/cmW0uKFBTQqvnCVQD8I9XNMZHTR23Kd4VaYzhfD1y+Qe59l+z6cvLlj6m6mpC
         fPxgUqEO1PdXDrQ9f+KOGgQkJMH4dCn6O52YeKbzaDJynCYtwXX9LWFJDrwpKsq3Xg4u
         Ho9ar/T4eWodNln6uh8FchsAA0inXeMrI/equEK+690jjp4qKqUtuA5+bUm6qjyqC67i
         0qD8xlB3NUejL1G6ZjNfwSGB7Hy8iBI2BfyIfsNZBQ98m9tW8wkYLa1sPJItiPPH1HFC
         Ol2L0/q1QB68jN9gD09Dvg14lzpiAuDiryqTVQdgORdgxMFwvilLVZwPadnHb37u4Qj+
         etKQ==
X-Gm-Message-State: AO0yUKWKNW8vlVV2enz5gq9+dfs94oRa5p3UXAaEEZdKrALmF8r3p5L+
        j/IBXJjrhbFXPnF7Jp0lFImOVTDpE1Hy0BwszDmYHKjp6YMHmxkbqFcWQbCjAtp6TKUGUwbtV2m
        D9mRsg8yAhlMlx8Joi8q+
X-Received: by 2002:a05:600c:cc5:b0:3ed:2346:44bd with SMTP id fk5-20020a05600c0cc500b003ed234644bdmr1267217wmb.19.1679481244576;
        Wed, 22 Mar 2023 03:34:04 -0700 (PDT)
X-Google-Smtp-Source: AK7set8Thq76pPmJGxOxWXjQQrmoDtwTU00agbKDE5V4x+4LtRlKY6qAlszC5c92Bor2YpNIrUHo5Q==
X-Received: by 2002:a05:600c:cc5:b0:3ed:2346:44bd with SMTP id fk5-20020a05600c0cc500b003ed234644bdmr1267207wmb.19.1679481244334;
        Wed, 22 Mar 2023 03:34:04 -0700 (PDT)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id a10-20020a056000050a00b002d78a96cf5fsm6368842wrf.70.2023.03.22.03.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 03:34:04 -0700 (PDT)
Date:   Wed, 22 Mar 2023 10:34:01 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBrZmbfWXVQLND/E@work-vm>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de>
 <ZBnhtEsMhuvwfY75@work-vm>
 <ZBn/ZbFwT9emf5zw@suse.de>
 <ZBoLVktt77F9paNV@work-vm>
 <ZBrIFnlPeCsP0x2g@suse.de>
 <444b0d8d-3a8c-8e6d-1df3-35f57046e58e@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <444b0d8d-3a8c-8e6d-1df3-35f57046e58e@amazon.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alexander Graf (graf@amazon.com) wrote:
> Hi Jörg,
> 
> On 22.03.23 10:19, Jörg Rödel wrote:
> 
> > On Tue, Mar 21, 2023 at 07:53:58PM +0000, Dr. David Alan Gilbert wrote:
> > > OK; the other thing that needs to get nailed down for the vTPM's is the
> > > relationship between the vTPM attestation and the SEV attestation.
> > > i.e. how to prove that the vTPM you're dealing with is from an SNP host.
> > > (Azure have a hack of putting an SNP attestation report into the vTPM
> > > NVRAM; see
> > > https://github.com/Azure/confidential-computing-cvm-guest-attestation/blob/main/cvm-guest-attestation.md
> > > )
> > When using the SVSM TPM protocol it should be proven already that the
> > vTPM is part of the SNP trusted base, no? The TPM communication is
> > implicitly encrypted by the VMs memory key and the SEV attestation
> > report proves that the correct vTPM is executing.
> 
> 
> What you want to achieve eventually is to take a report from the vTPM and
> submit only that to an external authorization entity that looks at it and
> says "Yup, you ran in SEV-SNP, I trust your TCB, I trust your TPM
> implementation, I also trust your PCR values" and based on that provides
> access to whatever resource you want to access.
> 
> To do that, you need to link SEV-SNP and TPM measurements/reports together.
> And the easiest way to do that is by providing the SEV-SNP report as part of
> the TPM: You can then use the hash of the SEV-SNP report as signing key for
> example.

Yeh; I think the SVSM TPM protocol has some proof of that as well; the
SVSM spec lists 'SVSM_ATTEST_SINGLE_SERVICE Manifest Data' that contains
'TPMT_PUBLIC structure of the endorsement key'.
So I *think* that's saying that the SEV attestation report contains
something from the EK of the vTPM.

> I think the key here is that you need to propagate that link to an external
> party, not (only) to the VM.

Yeh.

Dave
> 
> 
> Alex
> 
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

