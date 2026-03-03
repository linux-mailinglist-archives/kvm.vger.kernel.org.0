Return-Path: <kvm+bounces-72606-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CE0NYlSp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72606-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:28:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1E91F7864
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7BBF4303ACB8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58ECB48122B;
	Tue,  3 Mar 2026 21:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNKrQJEG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uJhwdjs2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34F63E715F
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772573315; cv=none; b=R5sElN1JFLe0xf+bQ7ir75aVFXke3x3w92PIiAMYAe41Cf4IS0CGt5hOVHTMBqUDSp36FzCETtesm0xNHXmMmDg26xk+ss5wbuq2e7FAtsXKTQvz+tgmkuEXKyRa/juf723be/w3tyPmynVrqDCULONfg285Z+nDHOkHt8fgTgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772573315; c=relaxed/simple;
	bh=Qod5CvN+wKbwfLYP2ir/2G5TIkldAoqnTb2J9YCbEJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGqjREkKZFW13ml2Crp/dSAXR8VwLSm9c5vxf30Ja1lnGvQKYl5FeztfKpGIQnAcCxIZNwJgs82J4q85ZVfAbEs8DtdWWS6Y79tMvttfQUg3IC0ddChG00NJ6uG6n1nxHL6IIXZkVFcYZZxGbCD8Q8PJk2ZMTgi+tjpVmBf3OPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RNKrQJEG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uJhwdjs2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772573312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z9nkRjC4w6gdMipVmaH+SWgaMfofvXt8znyp0jQo8ho=;
	b=RNKrQJEGzKv+nxGFhEu09UumXbJ2vVDtSFUVfm0W1rWphEZv+weAq3lFPOQrbWV1Sqo/bH
	DnmYXiTW0e3uPwLlMVdTpOvy4TswxL4reOtWbamdx2V/ZTMeXT7TOge4Z3oTAXfs6oaCmP
	Bo7v821yisVZbZ8NMdSG+91ZC9MUsuo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-qf4bpwuaPpqqQnSyate8BA-1; Tue, 03 Mar 2026 16:28:31 -0500
X-MC-Unique: qf4bpwuaPpqqQnSyate8BA-1
X-Mimecast-MFC-AGG-ID: qf4bpwuaPpqqQnSyate8BA_1772573311
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89a178d7270so22851596d6.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772573311; x=1773178111; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z9nkRjC4w6gdMipVmaH+SWgaMfofvXt8znyp0jQo8ho=;
        b=uJhwdjs2iE9fhHApFxJMPf8OzdlPWWZoTLinDHHvBf7ccGkvYbGOnVxUbMtJNfdWuO
         zLPRi3477N7qvjCb+ggGMBsHU357Go/wjLWLLASWwROEca5VahrDVCShQSESgC1IEHsr
         Zy2WcGF69tV3Iw33oFBQGi3R9WqCgWwnlN+we0Iff3d3qCD53LVsG7wB1IMmgWrp3SIe
         vWQhEUVzTR87/DS8zAf1TZMKnaB0HDYmlk3zpV5eEzrMEi6zJjt3xLP6mRLs6krV+2o1
         4Ns/sdmpcRttacPMQZkq2/mSxQtleYAIOZm3vmigbM43EJZhO0pKTc5Nh/DK6+lzMwqO
         HGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772573311; x=1773178111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9nkRjC4w6gdMipVmaH+SWgaMfofvXt8znyp0jQo8ho=;
        b=gsKimumEMDbPNRMsahm/tMo6N5pYeMUbQaOEk05Iae86aXqPzYrxjvxjGYzTt9Vcjp
         yFBbQQQNOYcNuV4Pq6mDQqw1VlArNR5Cc+9xYYh312+305nFAl1necjQz2yKDJmc1rDr
         yCorrD+SfRJoRUoAErg4FMvp7GOItqqoeU3kedTPQf8J7GRfnf2+6iDNFM3dwLYaZ3uz
         mfzqgc/A/5FPKmu1CVnCbPJ0RZT6nqqR3XRRANnI0Yme8+hbcNktaUGY2qbNXF/uZFsm
         VuFaJwM9HKc1uXZm/TqKS8P9x3iyo9v+hV4IEAzArCOjtVdkLXSQyqnwmsDgRQsKh6od
         2xzA==
X-Forwarded-Encrypted: i=1; AJvYcCX5J1NWA5j1DR/kIbcnZHDNTaRrD9NjRxgjxoENNojQChAhXssqR7IwgR26u997gBajrFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnjlRnEC9euhjsGe9SJgpINjVuwwEVFqSrxvdAN+9F+gBrTke2
	2HDTqCucQStGInNYvc6oVx2/7NR9wTijGjJ0Lj7JyRVKRo1zzlRy1CB5sNHhonCP85UHA3Y6jJ1
	KlIPI335Qywe8WD8I09qObq8kzaENm5naKf7/gGbYBJCuP8mGPjJ3kA==
X-Gm-Gg: ATEYQzzVNtROQbP69VkgM632ivv5/TQ8tmYnm+yHSBcApAI6jO3ymT229XluadNQhHF
	Hq8yISM9GAcm/BiAhGo4nvBy7g30fdpkl+7GhhulIBDeq7HzSs6ddqrQX9+DrpeuFx9lwUN2rK1
	RfZAU4Lmjkj2LbBofskjw+l0p3FBIr1qJkrafftfNJp7+PR7YQ4lsgfhQD/GO2R51wFEg/uztFv
	TZY+662hxAQeznl5T2OH2Dz/wFnbjENkLDS4XnP4s1KgvJwJGUB5uUCbM9kUPjuvQuTVCLXnGsa
	CUjY+veQvOrZ7A7jxYB+/wgHdGo0jfWayXc3e+ZmvtESs7tHaOH3JQdHOoIcfDWuQgNUOjuzehc
	N1smO75A1r5MByg==
X-Received: by 2002:ad4:4eea:0:b0:899:f354:331 with SMTP id 6a1803df08f44-899f35405b5mr152384346d6.16.1772573310869;
        Tue, 03 Mar 2026 13:28:30 -0800 (PST)
X-Received: by 2002:ad4:4eea:0:b0:899:f354:331 with SMTP id 6a1803df08f44-899f35405b5mr152384056d6.16.1772573310431;
        Tue, 03 Mar 2026 13:28:30 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7374600sm141516446d6.29.2026.03.03.13.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 13:28:30 -0800 (PST)
Date: Tue, 3 Mar 2026 16:28:18 -0500
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
Subject: Re: [PATCH v3 00/15] Make RamDiscardManager work with multiple
 sources
Message-ID: <aadScmxkeyWBFLeg@x1.local>
References: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
X-Rspamd-Queue-Id: 7C1E91F7864
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72606-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,x1.local:mid,ozlabs.org:url,gitlab.com:url]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 02:59:45PM +0100, marcandre.lureau@redhat.com wrote:
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
> (should fix https://issues.redhat.com/browse/RHEL-131968)

Hi, Marc-André,

Just FYI that this series fails some CI tests:

https://gitlab.com/peterx/qemu/-/pipelines/2361780109

Frankly I don't yet know on why rust fails with this, maybe you have better
idea..  So I'll leave that to you..

===8<===
error: unused import: `InterfaceClass`
  --> rust/bindings/system-sys/libsystem_sys.rlib.p/structured/lib.rs:23:15
   |
23 | use qom_sys::{InterfaceClass, Object, ObjectClass};
   |               ^^^^^^^^^^^^^^
   |
   = note: `-D unused-imports` implied by `-D warnings`
   = help: to override `-D warnings` add `#[allow(unused_imports)]`
error: aborting due to 1 previous error
===8<===

The other thing is this series will generate tons of checkpatch issues,
almost only line width issues and unmaintained files, so they're trivial.
It seems to me it'll be nice if this series can land 11.0.  We have one
more week.

Please take a look when repost, thanks!

-- 
Peter Xu


