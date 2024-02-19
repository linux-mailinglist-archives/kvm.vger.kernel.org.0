Return-Path: <kvm+bounces-9086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B22C185A4AC
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FDA61F2389C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADBC3613D;
	Mon, 19 Feb 2024 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=ilande.co.uk header.i=@ilande.co.uk header.b="bVQOebX+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ilande.co.uk (mail.ilande.co.uk [46.43.2.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2036132
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 13:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.43.2.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708349598; cv=none; b=ceFXV6OSh1Je8MvWtbLdcftboODfGd6Rj1vf4vcPicMokZAx8QW3F8MY5vufLqWnCBqD2gkzP7yQ0McLpgaTrwQAwBw2mchG3G/4ebmmMlvfKiFALaEa/6ostsBIWqK1JxagE0GAFXFE0VdsYDszZR0WAfcd1TT1GCXUp2GmUzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708349598; c=relaxed/simple;
	bh=wHUGoUEyQh31pXezMDwbrJz1jcC+HNR7LSRDwCFrA9Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=JFhwLZ9kSFzI4jg0kuUF+3qE9iL8u1+3Rawfg0gG1PAiZnUPP7xqT15J0kNnJUCsWyZvFobgRvB1vhrhWMi3lpYFcjzUPEEqdH9N9BXm4vfpgkJ1gHgzpNEfYREsd2g6tQU90iw3eVl/KEGHJDWpo6SaxzNCF8Ev1vI8amFyYpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ilande.co.uk; spf=pass smtp.mailfrom=ilande.co.uk; dkim=pass (4096-bit key) header.d=ilande.co.uk header.i=@ilande.co.uk header.b=bVQOebX+; arc=none smtp.client-ip=46.43.2.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ilande.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilande.co.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0aWvBboA8K47AQKs99Fn8KvQP7kMoe34ZGTLUs9F1jU=; b=bVQOebX+bpNkOVyKV3kfDY52Cy
	BfMEjEaf3wXjq0mHVuOQSnl9+TOUPwgRw2Vr4vALO+JsAP60Vc0QKTY9KdWi+A5wdPBzDlGGJwwhd
	4Dp6KkDG5t7mY8OI0ib/q1Jnbc2usmMfn1fZxgQCErnwyKz7Z1OKH+F36rR6m7gZtFv4SsdcxfvIQ
	IdMLJwJCFZL5YUjuoScVfF1uFMLCpigwv4Qp85GNA4DS0jpr+0sLsmPFYNd8jwhkaTx5nreOSQnPZ
	1L6fqSgscXyO9SDlkpxChr1U5WiyaBWggdaBvIzGmNSKTMN8hGbHf+IJjsb4uUi5VVbWG+i6YlK4Y
	7/ZeIkFLSi7S7QuObHfSKPNCKniCy5/UL+flmctsyqvHaD0LohD8YEFNE/7PEHHsGjJMjGMX6oDnB
	pyhvofGnKqRsUbM43MR+tsNnhbgRja5bBC+khaNU2W0JXF1krI69rKboZxbczSfbU9ReJtrzcKZJH
	RuQMSKLUgKrI075CWmP9bu8fsg8hwYKPJZfIWz571/pVL6wU7zVsH5Hi0AmKS6rllYTyf8zXG2q0j
	Uu6LuUugHzOi9Dcm+3fZG8GAcKPJrQcugmGqQHDrTRckcEnO/LlZ7Q1q3leJI3RDrGRGi2i2fRClT
	MYn214SepJMv0E3Uj7fBs9cM3ZeajaDXKR/uMhoks=;
Received: from [2a02:8012:c93d:0:260e:bf57:a4e9:8142]
	by mail.ilande.co.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <mark.cave-ayland@ilande.co.uk>)
	id 1rc3ky-0002PU-Jb; Mon, 19 Feb 2024 13:32:32 +0000
Message-ID: <0a31f410-415d-474b-bcea-9cb18f41aeb2@ilande.co.uk>
Date: Mon, 19 Feb 2024 13:33:08 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: BALATON Zoltan <balaton@eik.bme.hu>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 qemu-arm@nongnu.org, kvm@vger.kernel.org,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Markus Armbruster <armbru@redhat.com>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-2-philmd@linaro.org>
 <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu>
 <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org>
 <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
 <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu>
 <2b9ea923-c4f9-4ee4-8ed2-ba9f62c15579@linaro.org>
 <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu>
 <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
 <CAFEAcA-Mvd4NVY2yDgNEdjZ_YPrN93PDZRyfCi7JyCjmPs4gAQ@mail.gmail.com>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Autocrypt: addr=mark.cave-ayland@ilande.co.uk; keydata=
 xsBNBFQJuzwBCADAYvxrwUh1p/PvUlNFwKosVtVHHplgWi5p29t58QlOUkceZG0DBYSNqk93
 3JzBTbtd4JfFcSupo6MNNOrCzdCbCjZ64ik8ycaUOSzK2tKbeQLEXzXoaDL1Y7vuVO7nL9bG
 E5Ru3wkhCFc7SkoypIoAUqz8EtiB6T89/D9TDEyjdXUacc53R5gu8wEWiMg5MQQuGwzbQy9n
 PFI+mXC7AaEUqBVc2lBQVpAYXkN0EyqNNT12UfDLdxaxaFpUAE2pCa2LTyo5vn5hEW+i3VdN
 PkmjyPvL6DdY03fvC01PyY8zaw+UI94QqjlrDisHpUH40IUPpC/NB0LwzL2aQOMkzT2NABEB
 AAHNME1hcmsgQ2F2ZS1BeWxhbmQgPG1hcmsuY2F2ZS1heWxhbmRAaWxhbmRlLmNvLnVrPsLA
 eAQTAQIAIgUCVAm7PAIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQW8LFb64PMh9f
 NAgAuc3ObOEY8NbZko72AGrg2tWKdybcMVITxmcor4hb9155o/OWcA4IDbeATR6cfiDL/oxU
 mcmtXVgPqOwtW3NYAKr5g/FrZZ3uluQ2mtNYAyTFeALy8YF7N3yhs7LOcpbFP7tEbkSzoXNG
 z8iYMiYtKwttt40WaheWuRs0ZOLbs6yoczZBDhna3Nj0LA3GpeJKlaV03O4umjKJgACP1c/q
 T2Pkg+FCBHHFP454+waqojHp4OCBo6HyK+8I4wJRa9Z0EFqXIu8lTDYoggeX0Xd6bWeCFHK3
 DhD0/Xi/kegSW33unsp8oVcM4kcFxTkpBgj39dB4KwAUznhTJR0zUHf63M7ATQRUCbs8AQgA
 y7kyevA4bpetM/EjtuqQX4U05MBhEz/2SFkX6IaGtTG2NNw5wbcAfhOIuNNBYbw6ExuaJ3um
 2uLseHnudmvN4VSJ5Hfbd8rhqoMmmO71szgT/ZD9MEe2KHzBdmhmhxJdp+zQNivy215j6H27
 14mbC2dia7ktwP1rxPIX1OOfQwPuqlkmYPuVwZP19S4EYnCELOrnJ0m56tZLn5Zj+1jZX9Co
 YbNLMa28qsktYJ4oU4jtn6V79H+/zpERZAHmH40IRXdR3hA+Ye7iC/ZpWzT2VSDlPbGY9Yja
 Sp7w2347L5G+LLbAfaVoejHlfy/msPeehUcuKjAdBLoEhSPYzzdvEQARAQABwsBfBBgBAgAJ
 BQJUCbs8AhsMAAoJEFvCxW+uDzIfabYIAJXmBepHJpvCPiMNEQJNJ2ZSzSjhic84LTMWMbJ+
 opQgr5cb8SPQyyb508fc8b4uD8ejlF/cdbbBNktp3BXsHlO5BrmcABgxSP8HYYNsX0n9kERv
 NMToU0oiBuAaX7O/0K9+BW+3+PGMwiu5ml0cwDqljxfVN0dUBZnQ8kZpLsY+WDrIHmQWjtH+
 Ir6VauZs5Gp25XLrL6bh/SL8aK0BX6y79m5nhfKI1/6qtzHAjtMAjqy8ChPvOqVVVqmGUzFg
 KPsrrIoklWcYHXPyMLj9afispPVR8e0tMKvxzFBWzrWX1mzljbBlnV2n8BIwVXWNbgwpHSsj
 imgcU9TTGC5qd9g=
In-Reply-To: <CAFEAcA-Mvd4NVY2yDgNEdjZ_YPrN93PDZRyfCi7JyCjmPs4gAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a02:8012:c93d:0:260e:bf57:a4e9:8142
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Level: 
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.ilande.co.uk)

On 19/02/2024 13:05, Peter Maydell wrote:

> On Mon, 19 Feb 2024 at 12:49, Mark Cave-Ayland
> <mark.cave-ayland@ilande.co.uk> wrote:
>>
>> On 19/02/2024 12:00, BALATON Zoltan wrote:
>>> For new people trying to contribute to QEMU QDev is overwhelming so having some way
>>> to need less of it to do simple things would help them to get started.
>>
>> It depends what how you define "simple": for QEMU developers most people search for
>> similar examples in the codebase and copy/paste them. I'd much rather have a slightly
>> longer, but consistent API for setting properties rather than coming up with many
>> special case wrappers that need to be maintained just to keep the line count down for
>> "simplicity".
>>
>> I think that Phil's approach here is the best one for now, particularly given that it
>> allows us to take another step towards heterogeneous machines. As the work in this
>> area matures it might be that we can consider other approaches, but that's not a
>> decision that can be made right now and so shouldn't be a reason to block this change.
> 
> Mmm. It's unfortunate that we're working with C, so we're a bit limited
> in what tools we have to try to make a better and lower-boilerplate
> interface for the "create, configure, realize and wire up devices" task.
> (I think you could do much better in a higher level language...)
> sysbus_create_simple() was handy at the time, but it doesn't work so
> well for more complicated SoC-based boards. It's noticeable that
> if you look at the code that uses it, it's almost entirely the older
> and less maintained board models, especially those which don't actually
> model an SoC and just have the board code create all the devices.

Yeah I was thinking that you'd use the DSL (e.g. YAML templates or similar) to 
provide some of the boilerplating around common actions, rather than the C API 
itself. Even better, once everything has been moved to use a DSL then the C API 
shouldn't really matter so much as it is no longer directly exposed to the user.


ATB,

Mark.


