Return-Path: <kvm+bounces-59728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8F5BCAE0A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 23:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 31FE34F5DEE
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 21:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E72B280317;
	Thu,  9 Oct 2025 21:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yc2S5kdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8327F732
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 21:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760044084; cv=none; b=Xq581DSM6b0sAgQEif+bbHd8tGoEtkB8kXeBpQnbYLon1y70faEBVA97D08P3aG5Y076s1O3/qgN/3UInubRXnhsISyjHftGP4HjoQCMoehbdgq5G8Bqi+hCIk+XfjxpLeA3LCqr0zzh9hVvLkQGvXxHDB/ttgHssEgfdmIFFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760044084; c=relaxed/simple;
	bh=OV+I+IGp1YV8FAiM6+jyoDdlbVuoNoNGaY5rFMMy5Jo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bktFdh9Bm5S2NwZGjI86UWhd8ZeTXt4R0LX/7DM0baY8k7Hs0O2g0Q16j+4jL2MhMHlvoFIj6eGqgT7KbIQPXWXYiMUqJF9ujeMdmjEGIHI4FBBlrne6MZZ714/1pHfahhthgGIOG0OC2CTkYDBkDVsHmYfxZYSAbKeIvUdafys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yc2S5kdr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so3032226a91.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 14:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760044082; x=1760648882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8yL7yrEAZqRgLh743AzR/f5Z0OSynWI9v8HtFYQ07Y=;
        b=Yc2S5kdr4RiCLnQnxio+hQKw7tL6k47SnvL/c8WxgfAMLFSvW4ZK90Jyf3PGkhEqnd
         rBVGxkefYrCHHTYswquOrONPHJkbUIPlm8Dgw1d8mwg+HHYm37CQCUthe7JuES5yj9l1
         +abi9d2sAnjH8WuEryZCbq5EeHPOs9yPCjWtkG6l0+s5GmPcniT3tOfUyAfQZMHIu5CH
         xyEJmkfzb8aJMINGszt8gxXuqq4VBGXfqLaGUt2QPB7guchxsenwI/GVR0aGWTP/IaW0
         NuMvRfotnNamVUKW/suTOku0W01dFECJSgP3sicq1lxs0LlgmUeFbgD9VYjWZ7elvnRY
         Lntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760044082; x=1760648882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8yL7yrEAZqRgLh743AzR/f5Z0OSynWI9v8HtFYQ07Y=;
        b=dQgBw6hRh2gC8shoyGZBGWeZie2C8EcsTJ+EZ8Xx9UeMOzdCV5pkHNHBC9jONigkST
         QJpqG4BjSJAr32f3DvXnyVYKMR3gbv37RKbzy02fs3BoLstCItcpq737ManfzQoGNhcv
         i/YpUloeBltDJL+qIOuzQNCocFQpyydLKgf9q9OAdwtMjPjxP40vju6kwj4ijLTwf5ca
         05YHkedHnYLBxgXV7TGUFipdkkAcOuxH5Mh9LA+D6Htrw6pr3oz/91uDq/HWLg4Icetk
         Y/fRkzIwoMLvocg1RH7qK6jf8lSHzd2IAxFOFDHz5kGG/xnm5B2oi9uoGE7sg2GdIdHi
         oaWg==
X-Forwarded-Encrypted: i=1; AJvYcCXYOabYsnbf0GOdpOAE9qPmL7f/O7+AfPH/rS7ioDyb23+XYEyZGVVcvnhEFBrxvnztWTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy+8/dmA8LuzKxchfKEUA+w6Peb5adv45mo9dNpYyPGbYuBykF
	z88OZCl1M6/7f7b4OK2qhVhZTMhliBoxSU6jwP2jnHaIz2plRWy9ya8u2I2nsR0aMRjLTDWmbhe
	0JVAOZmaw7rdF1bmukGZEW0R/CA==
X-Google-Smtp-Source: AGHT+IFa7bhAUExVtejbjYxKsPiltNShSzZ9oTvDxsSQAjUcMKhU7xutFVMSZXzLhoi6fKx2krGDUJN50iFC9VUElg==
X-Received: from pjyu10.prod.google.com ([2002:a17:90a:e00a:b0:32b:50cb:b92f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b89:b0:32e:d599:1f66 with SMTP id 98e67ed59e1d1-33b513cedd3mr12577415a91.30.1760044082181;
 Thu, 09 Oct 2025 14:08:02 -0700 (PDT)
Date: Thu, 09 Oct 2025 14:08:00 -0700
In-Reply-To: <dd948073-0839-4f75-8cec-1f3041231ed7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-2-seanjc@google.com>
 <dd948073-0839-4f75-8cec-1f3041231ed7@amd.com>
Message-ID: <diqz347riy1b.fsf@google.com>
Subject: Re: [PATCH v12 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
From: Ackerley Tng <ackerleytng@google.com>
To: "Garg, Shivank" <shivankg@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

"Garg, Shivank" <shivankg@amd.com> writes:

> On 10/8/2025 3:44 AM, Sean Christopherson wrote:
>> 
>> [...snip...]
>> 
>> @@ -659,18 +667,18 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>>  					pgoff_t index, kvm_pfn_t *pfn,
>>  					bool *is_prepared, int *max_order)
>>  {
>> -	struct file *gmem_file = READ_ONCE(slot->gmem.file);
>> -	struct kvm_gmem *gmem = file->private_data;
>> +	struct file *slot_file = READ_ONCE(slot->gmem.file);
>> +	struct gmem_file *f = file->private_data;
> 			^^^
>>  	struct folio *folio;
>>  
>> -	if (file != gmem_file) {
>> -		WARN_ON_ONCE(gmem_file);
>> +	if (file != slot_file) {
>> +		WARN_ON_ONCE(slot_file);
>>  		return ERR_PTR(-EFAULT);
>>  	}
>>  
>> -	gmem = file->private_data;
>> -	if (xa_load(&gmem->bindings, index) != slot) {
>> -		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
>> +	f = file->private_data;
>
> This redundant initialization can be dropped.
>
> I sent a cleanup patch including this change a few weeks ago:

Agree, and probably good to opportunistically drop this line in this
patch than to combine cleanups in Shivank's other patch.

>
> https://lore.kernel.org/kvm/20250902080307.153171-2-shivankg@amd.com
>
> Could you please review it?
>
> Everything else looks good to me!
>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

>> +	if (xa_load(&f->bindings, index) != slot) {
>> +		WARN_ON_ONCE(xa_load(&f->bindings, index));
>>  		return ERR_PTR(-EIO);
>>  	}
>>  
>
> Thanks,
> Shivank

