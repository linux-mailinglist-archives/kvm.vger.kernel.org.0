Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BAE6C3B10
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCUTzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCUTzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC72166E3
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679428443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xi2PAhl1/X1sZtFKV7ziXgFguzLsRLnrCRviZPPBROs=;
        b=E6pzdpecYNff2MgB55kfX/kJ/uQqeRq5U4w84ujoXtD4svS92DUdn5RaEU4vKoeVvo1088
        wGjqqh+G3gs8Jvdc4OCqoc/DjJnlRQ0TNtVztFxqWKftnwCY8g9TdljDvYwS/yQvBHNnKY
        7TkwSB/IvYnHjOJ/m3awLISebOccICs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-91JAnd_GO02AFTr2w0tUpw-1; Tue, 21 Mar 2023 15:54:02 -0400
X-MC-Unique: 91JAnd_GO02AFTr2w0tUpw-1
Received: by mail-wr1-f70.google.com with SMTP id v30-20020adfa1de000000b002d557ec6d15so872059wrv.18
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679428441;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xi2PAhl1/X1sZtFKV7ziXgFguzLsRLnrCRviZPPBROs=;
        b=7QexZEHZNUSj7+RzznftsK0ADi7SYDpA+rT7KNEcMS0CnTvQ3CgyK6O1WWkFecF6O7
         LZu0oU8f2fPG5+yp6WpZ6e1pHH5lVveYJpEdBouWiTVFgoJwdYL0QFQSHxj0p9dGeXvW
         hEOCV9nMThHWPvtdPgqNxw6K7KjljxQhxut4DVneQ4XcHSqie2Tj41amOShBv5bs21ej
         YHpbryc240T8VQYHCjkpztQDHCCHRvfcuEFlKSTmkD1Xg4iCUUwsgz2xvnpMC9IDGiLu
         bHY1uZfAgM22xZL6FRcXacdyPwWdvoyhYQoSsXg3SX2xOWMHgUYR0AH/era+x76s6aej
         n31w==
X-Gm-Message-State: AO0yUKUB/4VApvON3wZjaPfmN+kxIgysEPUIMAz1yrJiHway9GoRqrAh
        VOkchggHQheZr4qHsWVPD+J2DsfgwRDFC9CF9gZqctgKRhmX7SYbfOAe1kCSNx/h4sDYtE/VIxB
        CrwLfYgayehWa
X-Received: by 2002:a1c:7908:0:b0:3eb:3843:9f31 with SMTP id l8-20020a1c7908000000b003eb38439f31mr3069457wme.10.1679428440894;
        Tue, 21 Mar 2023 12:54:00 -0700 (PDT)
X-Google-Smtp-Source: AK7set8sCJ8Eh0Wi5Q2DOOU6n0YeMzIEMOKWHvrAmPdR4eo5tqhawitqom+z4+xdNSSojdgIRLY/Eg==
X-Received: by 2002:a1c:7908:0:b0:3eb:3843:9f31 with SMTP id l8-20020a1c7908000000b003eb38439f31mr3069446wme.10.1679428440642;
        Tue, 21 Mar 2023 12:54:00 -0700 (PDT)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003ed2c0a0f37sm14456234wmq.35.2023.03.21.12.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:54:00 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:53:58 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBoLVktt77F9paNV@work-vm>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de>
 <ZBnhtEsMhuvwfY75@work-vm>
 <ZBn/ZbFwT9emf5zw@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBn/ZbFwT9emf5zw@suse.de>
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
> On Tue, Mar 21, 2023 at 04:56:20PM +0000, Dr. David Alan Gilbert wrote:
> > OK, I'm just trying to avoid having guests that have a zillion different
> > TPM setups for different SVSM and clouds.
> 
> My guess it that it will either be the SVSM TPM protocol or an emulation
> of an existing TPM interface.

OK; the other thing that needs to get nailed down for the vTPM's is the
relationship between the vTPM attestation and the SEV attestation.
i.e. how to prove that the vTPM you're dealing with is from an SNP host.
(Azure have a hack of putting an SNP attestation report into the vTPM
NVRAM; see
https://github.com/Azure/confidential-computing-cvm-guest-attestation/blob/main/cvm-guest-attestation.md
)

> > Timing is a little tricky here; in many ways the thing that sounds
> > nicest to me about Coconut is the mostly-unmodified guest (b) - but if
> > that's a while out then hmm.
> 
> Yeah, would be nice. But we are still in the early stages of SVSM
> development, so the priority now is to get services up and running.
> 
> But the project is open source and anyone can start looking into the
> unmodified guest handling and send PRs. Making this happen is certainly
> a multi-step process, as it requires several things to be implemented.
> Just out of my head an incomplete list what is required:
> 
> 	1) ReflectVC handling with instruction decoder and guest TLB
> 	   flush awareness
> 	2) vTOM handling
> 	3) Interrupt proxying using alternate injection (that can make
> 	   sense even earlier and without the other features imho)

So all the easy stuff then :-)

> So its quite some work, but if someone wants to look into that now I am
> all for it.

Dave
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

