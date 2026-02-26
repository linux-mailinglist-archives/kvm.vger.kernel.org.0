Return-Path: <kvm+bounces-71955-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKsrChQjoGkdfwQAu9opvQ
	(envelope-from <kvm+bounces-71955-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:40:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 819F01A46BA
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB5BE31125B9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DBD3A7F4D;
	Thu, 26 Feb 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/zcpEmg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j91sDa6B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3738A3A8FF0
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772102257; cv=none; b=YY3ZTVY1yRsDQBfCzcvpQr6z3KClBkT0Ahe+1rUUJqVp1kVh2WzeK8R0T7GaUpCV/kv5e3Yx0FwXQXh8yw2qPcEDMC5OxIbvUnevUEt/93DaZxEs52zCyeGI2NLD9ZyJHGFpH+lpqGEtP2ZnkAjKLnWJdjkOK8GkRmrJl+wrIUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772102257; c=relaxed/simple;
	bh=Tv5FZngxtUMObUyVSHDwXyUEFdvPoPb16IYzDb2fhqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5E6vpQV3aU8YWsCUHFqPeMwUzswugf8Jph36+Ph/5pIocYrZ/MV+eYBtskaIIbGv+mQEfarndaRRTxP9FvwB4MCCiK1XbrtIipIqJWrE/BQo1Dk5zP5/bkX6YXmrENSYbuLgRAAIhwO0YoTAV0ZkA9VuSpBzJ1oVbEOYsD2MD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/zcpEmg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j91sDa6B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772102251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Sha0tlrmOYa0Rpb8cUAyArTKqhODwvWX97J3L8tcVRU=;
	b=g/zcpEmgJbOInlMZs7FA00XKtJYPRCB06GianRCGtlF8vXCY5KIdrzIhHxTXAnUAls8wDh
	plNfAj+YP3oSWP8rsE4Pa7sTIEAKQPNEBHEZhTNwTeHsrZloTFdDoGQAXgLNQ8HvbI18zX
	sJIiBlp3an5K7ORn8liQhGX4lzkSTnQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-lcmFB1tjP3e3OwGToMYJsw-1; Thu, 26 Feb 2026 05:37:29 -0500
X-MC-Unique: lcmFB1tjP3e3OwGToMYJsw-1
X-Mimecast-MFC-AGG-ID: lcmFB1tjP3e3OwGToMYJsw_1772102248
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43998727cdfso265868f8f.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 02:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772102248; x=1772707048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Sha0tlrmOYa0Rpb8cUAyArTKqhODwvWX97J3L8tcVRU=;
        b=j91sDa6ByH/ifBDkgnDoQGADvKf34CP+bHYah0o3h1INRfYVetczzb2LvnNB6bgd3N
         fR1J/YSnVczWAe5AqY0y9d3I8hK0w6GQEyvTfJSI9eaWPYk7uQrpUo0//BHSLfjlRDFZ
         nRDoiOsyqQ9qkdoAJohcP4/PxTCX+WJgMLZYSqynOX2kl9fd1EuMvye+4P4jcrnMIN4+
         RF3log+vjkCBkhy4BwqJoVQ1u5xrkC0iwzYGBf8NGFbA31F7z4UOgCXuxo01Zxg9/2ri
         55f7l48SBpBNqc2B7FBIqvMt/cmvNNw0XXRw3/5GLL6DKSToSZqg/3X2Q8HwG3liar23
         CBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772102248; x=1772707048;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sha0tlrmOYa0Rpb8cUAyArTKqhODwvWX97J3L8tcVRU=;
        b=GqIbzJ3U49wzSX/8xngtyKZSejgyE+kRHTGrHHfFZ73YGU9WVDGuEP6OvfKxSfUloo
         i+n+yevcJYdDO94wrCW82FXUkdNRmgkXdk61goTi8V3UaM5Kvf0okaZev4KikE/2X+4u
         q0qOCj8dn4XTeQLMpY5H70F+vn3IW6usfTstbU247ZEQ5Bte2gUDBVZU8R1hxnd0Al3x
         Ob97y4N9GEHi8yjzEdrvbIa4ZYHAkPgcmS7jAj8hEkwZFBDuyDrmNYG6esA29s92otg3
         KRJ/4lgxtw5ew2M0DPBk8DoCEsrIa2k3NUhGJ+oL8ybQnK8VWWA/heQBvPlbYP3cELbO
         dmVg==
X-Forwarded-Encrypted: i=1; AJvYcCWsNv3vOWeeZ6cy4Mwp/sQPJtaN2owLicG+nRzfQNThXmA/0hkSgS5YMWY3PTDRaawVCi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDKn3PhrsDXTmyz7KDr7A8D19MKmrDZH3W5X8bW8sa9LqJhZEq
	Yfo6Sw3tT7pBmoNRBA5aNbJQpnnmGRiFcx91By5/PehfCsfmkMtPWohFmS+igZSZZTEadbuxgSu
	PXTOPfvU19uYhfxP6sGA9V2OPe/3Vlxty9ET/2NGK5ymxmaqSGWCcWA==
X-Gm-Gg: ATEYQzxvrOqoDy9A+gjkE/NnjAldvyj3buVzyLv2dNerBgJ1NA5ep0wFWR0NHI0VqP2
	5v+1Avo61wstsGfL/cUl/vJhmlFJ1Z6fAvJYRZ/sR9xzmS/kXJf9ei+aRyebKgWgwlCG38W846N
	Y7p6eSFiK0hgmeREE9+fdMyBy/NDWdfmsxrFpOg+2me6Q5K112EBOULCl0/9jPNymvZ6vuYTjiH
	ETN7Kj1XglmTz1qA6MFj1LZBGNiEV0zP7B0Ne7ck7Fpkq6ipFCLs5Svta3NLsy4a/qE/xrkKD8L
	gLRbWxaGmw7twQ0o7r/gkOU47ce3O+lLZ001NySGQcvBYq6lQyJtK87N4t2aMYi2LproNk6TaqO
	w2zZUcyuLM30Ft2jxZtrej90u575oYVOUEuhMuToKZ3aT/fNT9MAD49NLQA==
X-Received: by 2002:a05:600c:4f94:b0:480:4a4f:c36f with SMTP id 5b1f17b1804b1-483a95e2488mr313974305e9.21.1772102247938;
        Thu, 26 Feb 2026 02:37:27 -0800 (PST)
X-Received: by 2002:a05:600c:4f94:b0:480:4a4f:c36f with SMTP id 5b1f17b1804b1-483a95e2488mr313973765e9.21.1772102247443;
        Thu, 26 Feb 2026 02:37:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:165:d60:2c1a:3780:4e49:dfcf? ([2a01:e0a:165:d60:2c1a:3780:4e49:dfcf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd765604sm121443315e9.15.2026.02.26.02.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 02:37:27 -0800 (PST)
Message-ID: <0acdccaa-33dd-424d-a206-e413971d23ce@redhat.com>
Date: Thu, 26 Feb 2026 11:37:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/14] Make RamDiscardManager work with multiple
 sources
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Mark Kanda <mark.kanda@oracle.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Xu <peterx@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 Fabiano Rosas <farosas@suse.de>
References: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-71955-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ozlabs.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 819F01A46BA
X-Rspamd-Action: no action

On 2/25/26 13:04, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Hi,
> 
> This is an attempt to fix the incompatibility of virtio-mem with confidential
> VMs. The solution implements what was discussed earlier with D. Hildenbrand:
> https://patchwork.ozlabs.org/project/qemu-devel/patch/20250407074939.18657-5-chenyi.qiang@intel.com/#3502238
> 
> The first patches are misc cleanups. Then some code refactoring to have split a
> manager/source. And finally, the manager learns to deal with multiple sources.
> 
> I haven't done thorough testing. I only launched a SEV guest with a virtio-mem
> device. It would be nice to have more tests for those scenarios with
> VFIO/virtio-mem/confvm.. In any case, review & testing needed!
> 
In a SEV-SNP guest (BIOS) with a VFIO device and virtio-mem device :

   -m 4G,maxmem=24G
   -object '{"size": 4294967296, "id": "mem-vmem0", "qom-type": "memory-backend-ram"}'
   -device '{"id": "pcie-root-port-1", "port": 1, "driver": "pcie-root-port", "bus": "pcie.0", "chassis": 2}'
   -device '{"memdev": "mem-vmem0", "driver": "virtio-mem-pci", "id": "virtio_mem-vmem0", "bus": "pcie-root-port-1", "addr":  "0x0"}'
   -object '{"size": 4294967296, "id": "mem-machine_mem", "qom-type": "memory-backend-ram"}'
   ...

   [    0.663227] Memory Encryption Features active: AMD SEV SEV-ES SEV-SNP
   ...
   [    3.199716] virtio_mem virtio2: start address: 0x180000000
   [    3.200988] virtio_mem virtio2: region size: 0x100000000
   [    3.202217] virtio_mem virtio2: device block size: 0x200000
   [    3.203475] virtio_mem virtio2: nid: 0
   [    3.204384] virtio_mem virtio2: memory block size: 0x8000000
   [    3.205696] virtio_mem virtio2: subblock size: 0x200000
   [    3.207193] virtio_mem virtio2: plugged size: 0x0
   [    3.208282] virtio_mem virtio2: requested size: 0x0

boot is fine.

Powerdown reveals an issue :

   [   25.054116] ACPI: PM: Preparing to enter system sleep state S5
   [   25.055671] reboot: Power down
   **
   ERROR:../system/ram-discard-manager.c:459:ram_discard_manager_finalize: assertion failed: (QLIST_EMPTY(&rdm->source_list))
   Aborted

Thanks,

C.


