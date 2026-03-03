Return-Path: <kvm+bounces-72607-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPsvHlhTp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72607-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:32:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EF17D1F7900
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 754043078A0F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D705B481A8C;
	Tue,  3 Mar 2026 21:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eovOSDNO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HM7NCjCS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65F53537CE
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772573513; cv=none; b=LftCX3sDdBvBDuWkBleWUTGqMYKmmml+TXQhOJTBBx1pqRSuRKBNNxg1avZGab+LoRNLhevW1giGLI1kNN0e0DA0LGRYGGnJcxid87b8AntPWIwAsyFPZFMybZtkEy4tTJ3laffn5EBV8tRVE/4JEcFU5U7XbkqJh0ReSouaq6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772573513; c=relaxed/simple;
	bh=ZVTr/CWJA74uj36b+ZIVu32amxf+wNFAA74jc3MQT9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRajfxhrWtwKVVZ6eHTnLjybpQdqsYoNLOBJdppIERp5Cu3Nlz5QIndoRwlVipGxVAxKHoRL68Tau95J0MZkqWhufJpqFPUVRju60FPWLohDgTtZ5+eXDxYygOycPw630u8pSkaTVfeALA0GCJO77Co7EeIlE7RSSeD8wmva8PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eovOSDNO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HM7NCjCS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772573510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZuCvC0jKVdp/Y15R60BLqARNhNm25a0ww2zpI2Lh28=;
	b=eovOSDNOovw5uh7xbp7n3+hxe+XUybyjIzuJH/VpkA2m88LuSgFdLBMkb4Ug0lAoEBKsi9
	Us06Ql9mosd5zj+cdMQcRDRWRkA6Qt2RF9zhq1R3g5vYwJdk7UIqlDZhnt/WfKG8JI9aT/
	RMH6ej7jV2Kj6coN6Pft22NO4nkrInQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-VjEYCCHEPkmWXh_Rta8LQw-1; Tue, 03 Mar 2026 16:31:49 -0500
X-MC-Unique: VjEYCCHEPkmWXh_Rta8LQw-1
X-Mimecast-MFC-AGG-ID: VjEYCCHEPkmWXh_Rta8LQw_1772573509
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c70d16d5a9so3741418885a.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772573509; x=1773178309; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XZuCvC0jKVdp/Y15R60BLqARNhNm25a0ww2zpI2Lh28=;
        b=HM7NCjCSYW93WDxv2t4GnUy/tFH56ecVkHFSQ98m0GY04auqUFQSCIwLil5ZfhjogQ
         1EuTRqRlcbP0Y4j75hmRJOsmbIWE2FQm4oK/53FYq042Be0icGhT3/7gaut6HKcDWyB3
         giODv/+msT0Fr4NRwdDSeeEl1wsOZDnz2Y6ejCXBCeJkA+LKzQ/P911O/3QTlDwaZZsq
         hd3my88F9wuy1Or84MqsCuBZ6USXrXXjprtcrY3MKOp0Mq8lfdEfKZvgIqMH39j1Y1Tf
         JFKTYPmFeFk8DN1bK8JbVUuFqMPeA3zEZrXbndHPxuD6/bTY8FGMqZz+o1NSKZ0CViLx
         YF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772573509; x=1773178309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XZuCvC0jKVdp/Y15R60BLqARNhNm25a0ww2zpI2Lh28=;
        b=dBbrtCL1RJ7kkYwfgGVtNwjlfE8Wh+6Oq63GSL3wVfXlYiKG865a9MiqezOcdrpO3T
         RzuRjmPaetUVN4DYFHFo2GEacE+uWmH0sQm74C3qcH1+som91c4FlS1+CRYcL+Fxg8Ck
         w/xHuqzNl1zSfzccXM6a9z7uvw/ET6vqwvpc1ZCybmXt1Q2oud1mNBPN4L2/gcGkfLh4
         4vB4Xc6NHtJHe6F5yltMeDjXBNgvDpAvaaNUfP+jGWq93WbL5MaXLxJTsM+TQ5vehHIX
         ocfpYq8lXknJtXz4L+ejcmt+qPgb67kV+07rDiIifiZIT/Vd4Ru2bcJ8dJpKifoomjeG
         Bciw==
X-Forwarded-Encrypted: i=1; AJvYcCWG5eb8O88D0pRV5LZ11SGuPRqFOn/ONMvZWoqwm5BpilsLg7/m8suRvI67WSMYMCfyHkE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe7ko1pfVJYRPuY8wcht4z6qaXZ/Whq6YzgbPHpGiDA7yt/YFH
	Pr15q3zyAAk3w6Cc+eNcKvn1PhbdvpgTD91lQn5GEesRTO/GXjw/RV0VV16bAO/q1vXcih34JKX
	IcQD9KgPm6SG0AHBGDUjEZrn8EFrQh5iN1CzsfVqO++G9CNJQSUVavQ==
X-Gm-Gg: ATEYQzzk09MqxLrsTgLWfCtHFVZ5wTaXMPtRqV4JANZ/SGyb90n81xcMnY9cmOQpmCd
	NilUmQf880y0lEd9USG+bZxTcrpcoW1quGHTeLmN3o9bSdtZPswduQI7O7Kz/CrErCUG1qEtX3e
	INs47C54D4/DbGadZgDCsfb2gp4im/vm8IPhlW6QTuA9W6qt234snVmpHqEKx2HjvFPMKdtJ36O
	gn3AFiPGMvKU+U5bnx30Fe3rb1sw2Q5oeA1xmeiYMAxTfCPV7x0T+6MicV/t1pyzYGhYQMKH1kE
	7FbDRyrJ14ZVkaHgVB5J6a6r3KHQqcjUWxFjdVfVjlKo9daYns3c7zCQAZObeYQ7Nj1pDTzrtQS
	bcd2QCETsP0R9QHa9FwTeh61OhZyu2zLbYVhLoVlOC/oF4i47xtl7IAoErQFenTykGm/jNcqAdl
	dyIg8HjQ==
X-Received: by 2002:a05:620a:f0e:b0:8ca:4438:b91b with SMTP id af79cd13be357-8cbc8e080d0mr2163100285a.57.1772573508879;
        Tue, 03 Mar 2026 13:31:48 -0800 (PST)
X-Received: by 2002:a05:620a:f0e:b0:8ca:4438:b91b with SMTP id af79cd13be357-8cbc8e080d0mr2163096185a.57.1772573508284;
        Tue, 03 Mar 2026 13:31:48 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f93b5sm1469301785a.31.2026.03.03.13.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 13:31:47 -0800 (PST)
Date: Tue, 3 Mar 2026 16:31:46 -0500
From: Peter Xu <peterx@redhat.com>
To: marcandre.lureau@redhat.com
Cc: qemu-devel@nongnu.org, Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org, Mark Kanda <mark.kanda@oracle.com>
Subject: Re: [PATCH v3 13/15] system/physmem: destroy ram block attributes
 before RCU-deferred reclaim
Message-ID: <aadTQkmr4yscUpyr@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-14-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-14-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: EF17D1F7900
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72607-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:58PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> ram_block_attributes_destroy() was called from reclaim_ramblock(), which
> runs as an RCU callback deferred by call_rcu().
> 
> However,when the RamDiscardManager is finalized, it will assert that its
> source_list is empty in the next commit. Since the RCU callback hasn't
> run yet, the source added by ram_block_attributes_create() is still
> attached.
> 
> Move ram_block_attributes_destroy() into qemu_ram_free() so the source
> is removed synchronously. This is safe because qemu_ram_free() during
> shutdown runs after pause_all_vcpus(), so no vCPU thread can
> concurrently access the attributes via kvm_convert_memory().
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


