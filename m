Return-Path: <kvm+bounces-72593-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFEoH4I6p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72593-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:46:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF251F64D5
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DECF2307670A
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F7937C903;
	Tue,  3 Mar 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYxxjDJ9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZHnpM4Ai"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9537C912
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567147; cv=none; b=hf2LvnmsVYN02thK2nQYuVbTCvCSGhl05en53FbWXVEVekPoSVBGS5ifiwVXd+kaZIzAiC4FWwk7yuq5VMj5+PcDn3QfgOZJWvy0Fa6WjB3NMe90KSXb2i9qDCCELNIv6xDgXNO+QmV1PUzaBJ20T+DxBvgAzN8H0bG/+11MK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567147; c=relaxed/simple;
	bh=ATrWuqJBPSuTlb6rFgTsYd0m4srUaS0I2HKLFB690CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=at/+3ZJnIDD6pe8RaVrPVpifG7HVwA9fViCTM7fs8wdne87CMu60Fk2cHC3x96wiQ/tM2g1JRtE57kZezKYYjHCmzxYJVdkFRE5/2ZKqkX/Dh+CI8fcw8m67HlMFSqvg8FRK8plW2XATFtja54fB/z6iA0sEG+SmOg33jrQ8mAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EYxxjDJ9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZHnpM4Ai; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772567145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8HZgp9XakXoEVO+MoS+jYkmrGbeIxwxjBS2qScpvZo=;
	b=EYxxjDJ9cf0djs5HwNKwsM/wiaeITSrV/mWGc6iklbUBgCDyouk6i6w+3r6+HYGCJwjv+E
	n5eHPGu6BXzhWPVHWFUbm2B2BxLbuxcE5UXNt2lfJ2AbqVi6DZl01cs8z5RgMoJQcVICPs
	GMZMBqw5g7JyYCnZd1ct2NxN3Te3rTw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-rhg5v6L8Pz-zpCzkxUOygA-1; Tue, 03 Mar 2026 14:45:43 -0500
X-MC-Unique: rhg5v6L8Pz-zpCzkxUOygA-1
X-Mimecast-MFC-AGG-ID: rhg5v6L8Pz-zpCzkxUOygA_1772567143
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5075d3ee219so348716901cf.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772567143; x=1773171943; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s8HZgp9XakXoEVO+MoS+jYkmrGbeIxwxjBS2qScpvZo=;
        b=ZHnpM4Ai/iexo9xaAYCkz+w6u4qW+EPt9WqziM0w90hA/eAclZrVOmjeuzVUm0Y5Zi
         vi6H1MAMSUct4PYrHGcjBogClqrFD+SPcpx0yN3J7tMguYZkQ42pWmLbqVGBp3hSiNa3
         lL7xITxNDrmWNXwSPb4wt8Xvohb7WIIBpP96t9YbvfZWnB+CFk04AUEQOuH6jmszyc+1
         iMWUV9qbWPsoumu0KYlwsb3IiBCqAcWhME+J0yt3l9egW/CGsJ0khoGnAOEmU3OcmXgG
         dEiiuG4Z2amnvLngsRHLPAehbMViwZvctILGv7zN2RBCO0LqZy0zc89Ift6lpjsrf2Ar
         wvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567143; x=1773171943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8HZgp9XakXoEVO+MoS+jYkmrGbeIxwxjBS2qScpvZo=;
        b=uOT7i5PZ1gFiIZcZ2EUwnfEdSkjUwO10QJX/iVrKagTq+mbWG8QbQ3wP0SKooPdPu5
         V+/WUt0yxJkhe4TZjC5cDwI4ZJH90mKmyXn8pH4zn8iVpb9MAiFO2OGB24Kpq/RNNFeX
         oJ2eAChkf12wyGgMgR5sbZVg4FGURj15ddg+iH0Xvf7OU1jiONWgxJWP6HuLtgYUxxyx
         5kIQ+1ry3YWEms0XvUjV8jiH60RivisXO/Stw0nRm23BIuEo287MBug6Je8ObP0JjxpD
         R8Cf5TeYTMisP9S/G56Ci9ccp8/Pu0cPsxDbcX0Jux/5yV8fzMdayIK0MKwkbcqfkxm5
         QO8A==
X-Forwarded-Encrypted: i=1; AJvYcCX09yzJKsw36kfdKbtd9Q9jf4WZ6MSQ3buV3V2D3AhJh0TTybty1kz+EEOTFe8TzmMkBB8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe8b1OEiUuSkh10fLyrnIdpjzA38WiXEpagnT6AdTMnC2yvK/u
	GqThLH3UnLrxqSnwj8QCVQBHyrPEEN1P3MblCqkvJggYlUE//CCD/7r/LeMGnmulyFNHZj+I/xe
	leqFDJZGAhbbhog06EtaEsEhsz3KLskZcTjwBDMd4LYNhGH9Xn1sscA==
X-Gm-Gg: ATEYQzxiMCckkMS5V2Umkv2LW/VCpvJsxnyP7DaqMtqC4f1boMAQEfesSsfoeak5vrW
	DFhsqMRnXShtHNJvUpHlw1p5DPTotri0mqaCNho21I20k8SvDIHZj2JyXDVwWcwoP8r6V4w7cL0
	r1k+weU1jJH//TwXUX//gYVzrU8RIuksKj/Jsibkq7GXwaaSL1dUl78/KN8/ZVGFWEDXqTvuA06
	bbxnKLvDoIIVb850J8UWCwPqBb67nf+DkG301ZEtu2mHMbfCh3tAKPDJH1MQMIYaFf9BwKPxUTa
	p/EqHm/EUCAU+jZkYTJt865Om+QcW6mF5fPxGog1V/fIioxPUzvPfFrEuuZiycBF7s3rjO8Hl3x
	iyqcCdPY0gbmp9g==
X-Received: by 2002:a05:622a:1654:b0:506:bdd1:798 with SMTP id d75a77b69052e-50752936717mr211228241cf.52.1772567142923;
        Tue, 03 Mar 2026 11:45:42 -0800 (PST)
X-Received: by 2002:a05:622a:1654:b0:506:bdd1:798 with SMTP id d75a77b69052e-50752936717mr211227871cf.52.1772567142400;
        Tue, 03 Mar 2026 11:45:42 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744986357sm132369131cf.8.2026.03.03.11.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:45:41 -0800 (PST)
Date: Tue, 3 Mar 2026 14:45:30 -0500
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
Subject: Re: [PATCH v3 06/15] system/memory: split RamDiscardManager into
 source and manager
Message-ID: <aac6WsLDu3eygATm@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
 <20260226140001.3622334-7-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-7-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: DCF251F64D5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72593-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,x1.local:mid]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:51PM +0100, marcandre.lureau@redhat.com wrote:
> From: Marc-André Lureau <marcandre.lureau@redhat.com>
> 
> Refactor the RamDiscardManager interface into two distinct components:
> - RamDiscardSource: An interface that state providers (virtio-mem,
>   RamBlockAttributes) implement to provide discard state information
>   (granularity, populated/discarded ranges, replay callbacks).
> - RamDiscardManager: A concrete QOM object that wraps a source, owns
>   the listener list, and handles listener registration/unregistration
>   and notifications.
> 
> This separation moves the listener management logic from individual
> source implementations into the central RamDiscardManager, reducing
> code duplication between virtio-mem and RamBlockAttributes.
> 
> The change prepares for future work where a RamDiscardManager could
> aggregate multiple sources.
> 
> Note, the original virtio-mem code had conditions before discard:
>   if (vmem->size) {
>       rdl->notify_discard(rdl, rdl->section);
>   }
> however, the new code calls discard unconditionally. This is considered
> safe, since the populate/discard of sections are already asymmetrical
> (unplug & unregister all listener section unconditionally).
> 
> Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


