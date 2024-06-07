Return-Path: <kvm+bounces-19068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCCF900265
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 13:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5930F1F21628
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 11:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E997818FDD3;
	Fri,  7 Jun 2024 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bP8Om1/L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A87D187336
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 11:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717760362; cv=none; b=T4K4SknujfFYVcccXK6BBqYS4rLfgfE4mpUywfRtRTTqIJxuu4mXvW6dbEN3synnUy3HT7pknXNg0aPWLsvTVaS+SGaIZk+rwKTavVTtsc27pcPA+fgiERSyQEl9cvIGGTNPsrjJAJERLJtvczjmaAZ4qOuA0V+7osP9MG8X4mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717760362; c=relaxed/simple;
	bh=e84aLCdKh1EShx6as1qrt8Lq6oYac6YaHWvxgNpoL/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dGY48D3iayvPWDaI5oGhwTzjwS10mkV/iEA7PJUI671hykm7BjwJpkhmV/yskm3TfLILkTCfeWwJqTaAA5v2m07aS/E8HmO8el7Kz1HZSdDu+kiXIqE6REbDcVcVqhsAAM4IGdju0WqE2Io5hjrp+Z2/Clj6vtFmii031eo+RlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bP8Om1/L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717760359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e84aLCdKh1EShx6as1qrt8Lq6oYac6YaHWvxgNpoL/g=;
	b=bP8Om1/Lkckr9o+y2fbfHsp7vtKdr8mMrcnqqRiHK5Tn4bwvNvFDjvFLq82vGDm+BeIWCO
	nFg+6W43BeksUMAel3VIVnOwHXRqCiobQR/KG02pSEZbHcALRrLwFKZ+JgGAD+si2GuCl1
	sbVioZXu6K9lPg861BXXCPV0dDeghr4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-LAz_klnsNfCNj15aQmwh_Q-1; Fri, 07 Jun 2024 07:39:17 -0400
X-MC-Unique: LAz_klnsNfCNj15aQmwh_Q-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52b890339d9so1623789e87.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 04:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717760355; x=1718365155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e84aLCdKh1EShx6as1qrt8Lq6oYac6YaHWvxgNpoL/g=;
        b=E6XBQ3KMipr3nFoam9Esh4n9+IZbUWHfTmuanKzV3Ywqis6AscD9JY1xSUDbeGvQQU
         mtGfoeiv5av8274U2NuxvHN3BtmKgn39emhTFC6PltZ5xze8Ohz+Ns+mQOGPeINL8vCV
         YIEbH6g7/8c4gbj0lIXZ+hKyO6qhuHgT2l4yEGb85DVD2mZ7SoZMadBTuwaTFa61rjjL
         eRlx9frju3lidEWKr4k2Jb2W5RthrX93CMPsBAqKEkl3v8MN/eilnd0ps/Gmyc32OrrP
         u6xCvzTBpoN8WjehFmgawwnwqz3FQjFpTUELuD6kU0fVpnnMgG+flmzSVVV7iAgJf1QF
         iweA==
X-Forwarded-Encrypted: i=1; AJvYcCXnm6V59qmu6AVlHUjqgxgofQF42cr6UgkQs2DjZEDalAQD1SHeW9dO98dopncHWXyFCtgCrrANApbKrmjZ74Ufk9LA
X-Gm-Message-State: AOJu0Yyk4n8aldiHnC2r+4ctc8rfD608GyscsjSDf9a6C6diH+oOLs1m
	xYmvqKm3KeYoWx0leftLNWzb5ciKN1p5eqiS1JxquY+RsjzTYN1uywZ/slpfLiqWDkk7cPaAS7c
	TnrnoMIeqP0J/yfdeoxSAigMIbhvtmnC33O7x8s6nhf0Su+RzrbHN5Ql9q69+UcoB4DOiFAGqxV
	1KqksXUgG8V2A8VSTMCg1oFt6/
X-Received: by 2002:ac2:4835:0:b0:52a:8c03:35b8 with SMTP id 2adb3069b0e04-52bb9f81ab0mr1569132e87.32.1717760355432;
        Fri, 07 Jun 2024 04:39:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFttzSyjZ/xewoUaB7sRNrp9fxS6XKxR473AautxW/ZZSFxk2qTKh4+hDSwszrYSLV33Ybaxo8GBzeMDgJAS34=
X-Received: by 2002:ac2:4835:0:b0:52a:8c03:35b8 with SMTP id
 2adb3069b0e04-52bb9f81ab0mr1569115e87.32.1717760355033; Fri, 07 Jun 2024
 04:39:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 13:39:03 +0200
Message-ID: <CABgObfZigjQHxdHHhU3n1oP=wq-G2rS=AYaSzmPdP39qCUmrGg@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] TDX MMU prep series part 1
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> Hi,
>
> This is v2 of the TDX MMU prep series, split out of the giant 130 patch
> TDX base enabling series [0]. It is focusing on the changes to the x86 MM=
U
> to support TDX=E2=80=99s separation of private/shared EPT into separate r=
oots. A
> future breakout series will include the changes to actually interact with
> the TDX module to actually map private memory. The purpose of sending out
> a smaller series is to focus review, and hopefully rapidly iterate. We
> would like the series to go into kvm-coco-queue when it is ready.
>
> I think the maturity of these patches has significantly improved during
> the recent reviews. I expecting it still needs a little more work, but
> think that the basic structure is in decent shape at this point. Please
> consider it from the perspective of what is missing for inclusion in
> kvm-coco-queue.

Yes, now we're talking indeed. Mostly it's cosmetic tweaks or requests
to fix/improve a few comments, but overall it's very pleasing and
algorithmically clear code to read. Kudos to everyone involved.

I don't expect any big issues with v3.

Paolo


Paolo


