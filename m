Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5581E6C3898
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCURts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCURtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:49:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B16DBCA
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679420924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=el/8FR11MSLB/EaEV+UrmVaTtTZHDQdY7hcD+HbWEAc=;
        b=bKpWfug58qTj0cd0GY0cEy/AFugzVk1/Emh9yIwH6ZJ7gn1gZrWozdHt627BxpwHAG/7DY
        yXP5RSppbjEadeFPnzu6+hbl2RdG2/e6ATCwkVSFOsBeqcGu1pPUkhiYjhtjimt453t7S+
        4+KABZ7+03faYFm3qYkfGbcV+LmJaIo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-2sEwNY6AM4WOIP2cKM0uFg-1; Tue, 21 Mar 2023 13:48:42 -0400
X-MC-Unique: 2sEwNY6AM4WOIP2cKM0uFg-1
Received: by mail-wm1-f69.google.com with SMTP id m27-20020a05600c3b1b00b003ee502f1b16so237408wms.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420921;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=el/8FR11MSLB/EaEV+UrmVaTtTZHDQdY7hcD+HbWEAc=;
        b=SiGu3KbWX5Svw1DdHRxOZoP6Nbpbi/Qofb62W95usIjnisqD+i/Vje27tNoXaqwIiB
         lrawvy7PqM8OUxWXLd3j+1le3YVYiDlMTaBZ8HYo/VXuhf0bd1hKs60slAk9We6cORai
         IEWexk60BSYv4D+ynBhXHiEXJJP+hQu3W3YS2S7SRC3RGO2RaHbDvaT3egrucxHhkLcw
         L1sm4rDvsJCqXGoJnCwufm+HJAPenWjs+xliUa4+AO5NHXwEUfd5k3+KKnoQBgfROHq2
         rhTSNBT7CtPneEckoECXxTa1audhXPfS58+oeCKxqxhlfDi4/si3zglqlK92kKUBP2iJ
         s1Jw==
X-Gm-Message-State: AO0yUKUiPtSkQbmw6N6oeGlI+APou3y0e8qa1/K6k1L4UXwSY3vwKGmb
        9VJ5ywb7ztNJc+sSONMJhC6MgO1kOEIbBSR4rOijTK+2wqt+KDkBXBBaRHjTEtc7jf7qdoHENK7
        bd6ttCT20nIIx
X-Received: by 2002:adf:e4c1:0:b0:2cf:4583:6335 with SMTP id v1-20020adfe4c1000000b002cf45836335mr2840886wrm.29.1679420921638;
        Tue, 21 Mar 2023 10:48:41 -0700 (PDT)
X-Google-Smtp-Source: AK7set9OOda5pv5UQz1phm2CNDWtqB9rsjhLqdMKwfCXvzHQEsETLuh6DP0BbmPolCqKTlKIo3zV0w==
X-Received: by 2002:adf:e4c1:0:b0:2cf:4583:6335 with SMTP id v1-20020adfe4c1000000b002cf45836335mr2840872wrm.29.1679420921327;
        Tue, 21 Mar 2023 10:48:41 -0700 (PDT)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600000ce00b002be505ab59asm11799083wrx.97.2023.03.21.10.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:48:40 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:48:38 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     James Bottomley <jejb@linux.ibm.com>, amd-sev-snp@lists.suse.com,
        linux-coco@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBnt9pbSfp/v1bWO@work-vm>
References: <ZBl4592947wC7WKI@suse.de>
 <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
 <ZBmmjlNdBwVju6ib@suse.de>
 <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
 <ZBnJ6ZCuQJTVMM8h@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBnJ6ZCuQJTVMM8h@suse.de>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Jörg Rödel (jroedel@suse.de) wrote:
> On Tue, Mar 21, 2023 at 09:43:48AM -0400, James Bottomley wrote:
> > Could you describe these incompatible goals and explain why you think
> > they are incompatible (as in why you and AMD don't think you can agree
> > on it)?  That would help the rest of us understand where the two SVSM
> > implementations fit in our ongoing plans.
> 
> The goal of COCONUT is to have an SVSM which has isolation capabilities
> within itself. It already has percpu page-tables and in the end it will
> be able to run services (like the TPM) as separate processes in ring 3
> using cooperative multitasking.
> 
> With the current linux-svsm code-base this is difficult to achieve due
> to its reliance on the x86-64 crate. For supporting a user-space like
> execution mode the crate has too many limitations, mainly in its
> page-table and IDT implementations.
> 
> The IDT code from that crate, which is also used in linux-svsm, relies
> on compiler-generated entry-code. This is not enough to support a
> ring-3 execution mode with syscalls and several (possibly nested) IST
> vectors. The next problem with the IDT code is that it doesn't allow
> modification of return register state.  This makes it impossible to
> implement exception fixups to guard RMPADJUST instructions and VMPL1
> memory accesses in general.

I'm curious why you're doing isolation using ring-3 stuff rather than
another VMPL level?

Dave

> When we looked at the crate, the page-table implementation supported
> basically a direct and an offset mapping, which will get us into
> problems when support for non-contiguous mappings or sharing parts of a
> page-table with another page-table is needed. So in the very beginning
> of the project I decided to go with my own page-table implementation.
> 
> Of course we could start changing linux-svsm to support the same goals,
> but I think the end result will not be very different from what COCONUT
> looks now.
> 
> Regards,
> 
> -- 
> Jörg Rödel
> jroedel@suse.de
> 
> SUSE Software Solutions Germany GmbH
> Frankenstraße 146
> 90461 Nürnberg
> Germany
> 
> (HRB 36809, AG Nürnberg)
> Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

