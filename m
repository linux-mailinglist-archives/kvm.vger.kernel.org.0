Return-Path: <kvm+bounces-25961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 808DC96DF26
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 18:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3623F286708
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 16:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECC019EEBF;
	Thu,  5 Sep 2024 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjWxxkBW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2E819DF5B
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725552456; cv=none; b=XtDgfHpGVxlgAaJdcYDkYXO5d3mYYmUT16Y6q9XsW/MPDigjV54XyNcR8QLMBJ7JI/npYLysOhuM4+6mQCYCQtlJB/qf8JWWUmvvXDDN7vS+sxohhZ+SzMR9lXRzxT1h9o3EowelZXmmeqxJPY4F8uo7Zn0T7xekH9fjgRw5yqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725552456; c=relaxed/simple;
	bh=B7Hg5Mvh5FgNI234xWuwat/0R2ezwN45gVUjyNVeeP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMvD7JlhQ+KTfIOqThll1JzeEefYl6ccAjibYwOWrBds+UbLex+gUDtrWreWIukMrPsbQkp0G1j4wMVlg0wX5MmtxHytmOKBAjNJG0sXctsAohwBSYJ/mZOIpMT0HEMq1DExkPduJQHXzT2T4r+MFhYXl3wH35eluEILhr0zZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjWxxkBW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725552454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jp345HzFmHJEwidIfoXQdHcIH1v2W8J0QUu4Wb8LVnY=;
	b=hjWxxkBWJakUQ9TJEJPc023hFtTfGI3R8y7CP97SWwwFuwA4LugUUZkpnz25Dt2NGa4aSV
	9ZjjznoDlCNLZ9RU9dDMK8yYYROSOUZL6y9Lgcvwt7LLk/atS6Bd0nPpwB97W4cDMnYJg9
	GZt1qeVzon3JTycn1NjaKaaD3NqWoak=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-Vsp5dNE-Nye8VHEsd-YA2A-1; Thu, 05 Sep 2024 12:07:32 -0400
X-MC-Unique: Vsp5dNE-Nye8VHEsd-YA2A-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6c35b2ccf3cso14979876d6.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 09:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725552452; x=1726157252;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jp345HzFmHJEwidIfoXQdHcIH1v2W8J0QUu4Wb8LVnY=;
        b=Hj9RfHJhQvM//1Wp6a1apJ/rzvTg7Jd7SrLQ0ow8VerxVVuMaHJWPIKc+vjqwyrAda
         +70kuhQYkFUhhx3TPtV6des6e5pqjW5Cr94EsaA+h1Y+2sKcyhl+CnKFvLQAQoQw56OU
         3v11U1qytaywhGrTsnnxuYC6fBI+vzGCQYES5rLC9PSB4n/uoUw9J1PQmkvud5BYNfwH
         y8j21ZQ4W2Uc4ryluaaCPWl2jo/MJbqa7LTZC4bu4WIlyTM6f/1WXrZMePLtb35y3mhW
         p6yjinyHB5GZoHEV08UY9GKOEe/92MQ80JtqaStYbzBRKxEXsIkv4TqYqctKFXT9HlT7
         e4Wg==
X-Forwarded-Encrypted: i=1; AJvYcCVkqxC/WpeUHRTKPR5ja9VESY8yy35VWqJ+SUGnqHxc36rBX1GAw4P5yrLv9cb+LD89ESc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEBbFFvY12MDr/jN9nt/Ej/mnp7m1kHrtyD/omEZ/iYjA+tzzM
	d6n2+4DRNl33TTf/Xju8MVI/fvHGe7+mG0PBZZymmdd2/o1sOHOCeMkKToVWCyg5RKhwycU1ZKZ
	2Er3pkmulQn7Q2hnQuEqrRrFjcYIzVyC/1KX8jVuue97Jp4sZ3w==
X-Received: by 2002:a05:6214:4413:b0:6c1:77ca:66e6 with SMTP id 6a1803df08f44-6c3c62b3173mr102114196d6.32.1725552452190;
        Thu, 05 Sep 2024 09:07:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9oPe/vTAgFoL/H+kQAEzNzDMUJyoURSRMXRDN3RUKtP81UDTLVH45WHx48Puph7mxqvbWDg==
X-Received: by 2002:a05:6214:4413:b0:6c1:77ca:66e6 with SMTP id 6a1803df08f44-6c3c62b3173mr102113566d6.32.1725552451795;
        Thu, 05 Sep 2024 09:07:31 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c5201e42a5sm8659686d6.36.2024.09.05.09.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 09:07:31 -0700 (PDT)
Date: Thu, 5 Sep 2024 12:07:27 -0400
From: Peter Xu <peterx@redhat.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
	alex.williamson@redhat.com, andrew@codeconstruct.com.au,
	andrew@daynix.com, arei.gonglei@huawei.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	kwolf@redhat.com, leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, philmd@linaro.org,
	pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
	stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, zhao1.liu@intel.com,
	qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
	kvm@vger.kernel.org, avihaih@nvidia.com
Subject: Re: [PATCH v2 01/19] qapi: Smarter camel_to_upper() to reduce need
 for 'prefix'
Message-ID: <ZtnXP3_nB0vS5Ts8@x1n>
References: <20240904111836.3273842-1-armbru@redhat.com>
 <20240904111836.3273842-2-armbru@redhat.com>
 <ZthQAr7Mpd0utBD9@redhat.com>
 <87o75263pq.fsf@pond.sub.org>
 <ZtnTxNFmgJlaeLZy@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtnTxNFmgJlaeLZy@redhat.com>

On Thu, Sep 05, 2024 at 04:52:36PM +0100, Daniel P. Berrangé wrote:
> On Thu, Sep 05, 2024 at 07:59:13AM +0200, Markus Armbruster wrote:
> > Daniel P. Berrangé <berrange@redhat.com> writes:
> > 
> > > On Wed, Sep 04, 2024 at 01:18:18PM +0200, Markus Armbruster wrote:
> > >> camel_to_upper() converts its argument from camel case to upper case
> > >> with '_' between words.  Used for generated enumeration constant
> > >> prefixes.
> > >
> > >
> > >> 
> > >> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> > >> Reviewed-by: Daniel P. Berrang?? <berrange@redhat.com>
> > >
> > > The accent in my name is getting mangled in this series.
> > 
> > Uh-oh!
> > 
> > Checking...  Hmm.  It's correct in git, correct in output of
> > git-format-patch, correct in the copy I got from git-send-email --bcc
> > armbru via localhost MTA, and the copy I got from --to
> > qemu-devel@nongnu.org, correct in lore.kernel.org[*], correct in an mbox
> > downloaded from patchew.
> > 
> > Could the culprit be on your side?
> 
> I compared my received mail vs the mbox archive on nongnu.org for
> qemu-devel.
> 
> In both cases the actual mail body seems to be valid UTF-8 and is
> identical. The message in the nongnu.org archive, however, has
> 
>   Content-Type: text/plain; charset=UTF-8
> 
> while the copy I got in my inbox has merely
> 
>   Content-Type: text/plain
> 
> What I can't determine is whether your original sent message
> had "charset=UTF-8" which then got stripped by redhat's incoming
> mail server, or whether your original lacked 'charset=UTF8' and
> it got added by mailman when saving the message to the mbox archives ?

I didn't read into details of what Markus hit, but I just remembered I hit
similar things before and Dan reported similar issue.  At that time (which
I tried to recall..) was because I used git-publish sending patches, in
which there is an encoding issue. I tried to fix with this branch:

https://github.com/xzpeter/git-publish/commits/fix-print-2/

I also remember I tried to upstream that to Stefan's repo but I totally
forgot what happened later, but the result is I am still using this branch
internally (which I completely forgot which version I'm using... but I
found that until I see this discussion and checked..).

Please ignore everything if git-publish is not used at all.. but just in
case helpful..

-- 
Peter Xu


