Return-Path: <kvm+bounces-65760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B18CB5A2A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 12:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBB4D3010FE2
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8CD23E356;
	Thu, 11 Dec 2025 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MB9ju0Zb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2h6Jy9x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2039335BA
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 11:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765452643; cv=none; b=ad54uGWIIA2LPt+/mDBOQPseOG36G8zhrSwp3KWbt0W1PkSgC1/WIgN2Ce7ekhqYcY4d+BCSr0Zt3vL8GPy5j9yBSETRhcAArYHG1PBYwHXPoZYXVj+ZX3awLOck9OBCEjd6eKRR/nEgXTDyy65Fo2yjqQQr93jYP0cE+v0bPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765452643; c=relaxed/simple;
	bh=dqbYKvju4zHZbHYfmcA6Thj5Ul1hgVBNhE/Y4C5a2Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hwkjo6WXTZxSfltBwUzaG8GPfyhlqWFn1iv3BNSZc+FRwhBO02jVlNWb2UW159p8tTy3/Yzj0HRNJXncYzfDUnMcsiVFLhUI/ZCYwZaHLlSRxzhbDK8vIkkVG/stKydPSDdnSCBe7wnHNteHqNToxL3uLsRYf+ngZiErXmbpZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MB9ju0Zb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2h6Jy9x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765452640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Y9tFuYInlA47P9eA2ojGAB9FoYr24JbofHha9k42B4=;
	b=MB9ju0Zbr2ZYpdXjKDknh/6iDVTvOnXKU4H6Eam/DLAJnFT/sEIIL/HdHCAn41SOz6FcjU
	uSIHVIy7YWyMlpuaH7bouWwot7pQlepGAJ0zlIuyQbJinpqEVx9PaQA/mANr7pkHPaJg0Z
	f/WMrT1F7fep0GSRTwbIbpSK3dR6OBY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-SJUQ44AEOaueujYxGOm3Vw-1; Thu, 11 Dec 2025 06:30:39 -0500
X-MC-Unique: SJUQ44AEOaueujYxGOm3Vw-1
X-Mimecast-MFC-AGG-ID: SJUQ44AEOaueujYxGOm3Vw_1765452638
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso5935525e9.2
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 03:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765452638; x=1766057438; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Y9tFuYInlA47P9eA2ojGAB9FoYr24JbofHha9k42B4=;
        b=a2h6Jy9xd5PGXQwxsLlhzvQ500JJys5VOuX+tI5wzZsVimTN5rnrle+BQYJaaZMuZz
         67BgM1PdkPNuDL+yXnF057DsHwvMmQIvuk/S0j49FxzhgDp1XaURHWVyIFxoNXiQ3S9t
         mMl2bBFUFhA4zT0B90Q6bR/kv+NPWla2exqqSmRG97o5WYLrr6a1VESHZLikG1k2TFmX
         rwcwQcsnT7VYvlafJOdHYQk47MBNFOydsaa52RJwH1dHO0YmPG6zoGB6rxx91v4vGQ90
         J3XC4LZgJrM1gMoeecmjzWf4q7xDrQsVDN4GIp5TuUgvryIbMFJvsYWyTv7vy4fe/bPR
         2WZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765452638; x=1766057438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Y9tFuYInlA47P9eA2ojGAB9FoYr24JbofHha9k42B4=;
        b=Kyrc0oZ8sdj92Wnes98ILkz63Shj/0vjZlUz/eDexw1MekwPpdIWNpVpGDZtw0BAyZ
         zf7vmNb+bOntS3Z2XO8NyKA6IU5tgLg6/UADOLvNTfdzPEQIPefvkdocRV9XK9zj+ebM
         LCYf8NNHvN65DMK3afpiXyMj9j8XMTFBLp03DNtxT4oR8az4AD/M4vXXS0gyXRDyIjvF
         OzPETSrxCVS1V6eH9Fsosoi6dRTzb+zU2IlAEpvLJ/1fxNVHhVDw5u+W5sD9p2VDtjeb
         XEBOui2VIzBcfOyfZACy+5v2hWsnWWIe/ehcd4y5tPFtyHN/i/Q0RirbkwRn+49hcNTl
         zBLw==
X-Forwarded-Encrypted: i=1; AJvYcCVbswBto7qEUv21BMaZdnhx8hJYyx/DNL6BW8BEzBae6whh/5TCF+4WcD3jzWXT/LcqV+E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7AIHil/049IW6DMmrrgbEnEq8lCy4ar5SB/CrVRLn40jU+P8n
	L6dtOpDmHpWkkLHS1i+t/BlMM7PNbpUjtO80b05Q/vyeNCwQIKtQitYJn05iraYZTqpR2vwIZzN
	ijsRBarF2r47tEWiySC8MkxyrbO5OvoPf0NmWekk21wB3dQPpB1O1CA==
X-Gm-Gg: AY/fxX51Z3xGgH4W6HGEoGaffulxgpAoVonoFF/IdF4+V1PwIVwZvRM8n97kureVHQk
	9LBnBJ1Ba/GWg5tXYir8wf2LudQbQykBp9HM/wr5aM5+17NK2WUu5GSR8laRCPPriisEVb4820R
	+aEYrmijxp8JM6UxioLPCuFdkzF2CrhpAkjhygkg6njSaaZLTHuDcxeBVEwIFyxxmCSh/x9/FTq
	In3MFdiXdiiWiFXjFcgbBmPX8gcjhAX+/CY4O1K5CoOkyQfgi5iCCOmXMytgWiKp0R1YP1nI0ut
	V01+xW9aiCl2EgIN9M+Lzhmx4ObfxZEU5D2lknS5HVsRDa1Fj7PUIpHoQ1myTlN0tW8dvVhIVcy
	kUiIpQL81a1ePpEc=
X-Received: by 2002:a05:600c:1547:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47a8377e3acmr64056215e9.12.1765452638205;
        Thu, 11 Dec 2025 03:30:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/aiXL+VTKlK1niB/7QmaAPq43l5P7go4y7nUlbotyg4bvN63JqE547R5x2lkCEjuHSy9bZw==
X-Received: by 2002:a05:600c:1547:b0:47a:7fdd:2906 with SMTP id 5b1f17b1804b1-47a8377e3acmr64055775e9.12.1765452637793;
        Thu, 11 Dec 2025 03:30:37 -0800 (PST)
Received: from leonardi-redhat ([151.29.156.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89d1149dsm13006925e9.0.2025.12.11.03.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 03:30:37 -0800 (PST)
Date: Thu, 11 Dec 2025 12:30:34 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Ani Sinha <anisinha@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2 3/3] igvm: Fill MADT IGVM parameter field
Message-ID: <wcqcwrshe6nmz3lb5bz2ucdydwgsfxlxbua5jfaly677zsgy4h@dy3nypkedwhi>
References: <20251211103136.1578463-1-osteffen@redhat.com>
 <20251211103136.1578463-4-osteffen@redhat.com>
 <h4256m67shwdq4aouxpqadb2zozhq2f5dfeo74c5jnet5f26kz@a3av5xjfyfow>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <h4256m67shwdq4aouxpqadb2zozhq2f5dfeo74c5jnet5f26kz@a3av5xjfyfow>

Hi,

On Thu, Dec 11, 2025 at 12:15:59PM +0100, Gerd Hoffmann wrote:
>  Hi,
>
>> +static int qigvm_initialization_madt(QIgvm *ctx,
>> +                                     const uint8_t *header_data, Error **errp)
>> +{
>> +    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
>> +    QIgvmParameterData *param_entry;
>> +
>> +    if (ctx->madt == NULL) {
>> +        return 0;
>> +    }
>> +
>> +    /* Find the parameter area that should hold the device tree */
>
>cut+paste error in the comment.
>
>> +    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>> +    {
>> +        if (param_entry->index == param->parameter_area_index) {
>
>Hmm, that is a pattern repeated a number of times already in the igvm
>code.  Should we factor that out into a helper function?

+1

>
>>  static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
>>  {
>>      int32_t header_count;
>> @@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
>>  }
>>
>>  int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>> -                       bool onlyVpContext, Error **errp)
>> +                       bool onlyVpContext, GArray *madt, Error **errp)
>
>I'd like to see less parameters for this function, not more.
>
>I think sensible options here are:
>
>  (a) store the madt pointer in IgvmCfg, or
>  (b) pass MachineState instead of ConfidentialGuestSupport, so
>      we can use the MachineState here to generate the madt.
>
>Luigi, any opinion?  I think device tree support will need access to
>MachineState too, and I think both madt and dt should take the same
>approach here.

I have a slight preference over MachineState as it's more generic and we 
don't need to add more fields in IgvmCfg for new features.

Luigi


