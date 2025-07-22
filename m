Return-Path: <kvm+bounces-53162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D055B0E249
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 19:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D1A43A74DF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B810E27F727;
	Tue, 22 Jul 2025 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="nLYtFGj+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E52D279DBA;
	Tue, 22 Jul 2025 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753203601; cv=none; b=P2pkNt0C5N2jBrR/2aGaIiUZEhlaNiTpwXoMrFZJxUq4XAFF76PaDFA8u3vSh6Io1pf8prO905tfoHY1wPnuWWSrPC7wyIhjKXF3e0ghbH4ua46DOa0zIE23BiiImeLVIzaJy60k+b7d4z3+H8yzQ+vf0SkFZHWaupyZ5iUMNag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753203601; c=relaxed/simple;
	bh=FMRnyRhitE21Y1CE7xWJUhAoijIeW5UjFQ+cU+mOOMc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=YByRglemgoY6ne7QnrfbTtD0mXZCMC2/D9rm4l+Bor2E9N3/WtJHfagLm12yRTAL6Om6QihM3PLcWaKgqOigkgePTb+kpHAqGw1DAa9rLdC7UAOu/6po+4TfgjHFqySCh/ccfa+xtpmo2u/coW0zKB1x3kR2fWn6wkgKEGzwB5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=nLYtFGj+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56MGwnFd657671
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 22 Jul 2025 09:58:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56MGwnFd657671
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1753203533;
	bh=zcW3ufrPeS9z5vjFN56GirhJJTbdaCIUAEbrqpAovKM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=nLYtFGj+YjoGNEYGiQTtSSrpLjsViKYD5wc5TuPqddAJ8ED6zjoIGvwZgXShXXwZt
	 Z82UlljOtC8H/vyP3+1XHhLAhJvsSdBXSHJ84a1lkAM+dC0eOenHEapfk4l+xPw3Yp
	 Tt3Lpn5k1a8EeQHBGdtankMXR8c2x9H6h+0GL1KdQYwwtXGBVhacT1Ab7+XMA9Vwvr
	 jaS1KWf/6v6gMYlrDFaRXV8sXwAbLXlPwERIbq3nL8fW2l05WOB61yjvWDeSWsbJtw
	 LjgcnAROyJDyAmDWXrktO4r2jj7OpE+JXGo7pOG10BKOA/G6IDssVi679Ct4qgRD8y
	 fQKKcG4D5VH1Q==
Date: Tue, 22 Jul 2025 09:58:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Greg KH <gregkh@linuxfoundation.org>, WangYuli <wangyuli@uniontech.com>
CC: airlied@gmail.com, akpm@linux-foundation.org, alison.schofield@intel.com,
        andrew+netdev@lunn.ch, andriy.shevchenko@linux.intel.com,
        arend.vanspriel@broadcom.com, bp@alien8.de,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
        colin.i.king@gmail.com, cvam0000@gmail.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com, dave@stgolabs.net,
        davem@davemloft.net, dri-devel@lists.freedesktop.org,
        edumazet@google.com, guanwentao@uniontech.com,
        ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org,
        ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
        jgross@suse.com, jirislaby@kernel.org, johannes.berg@intel.com,
        jonathan.cameron@huawei.com, kuba@kernel.org, kvalo@kernel.org,
        kvm@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux@treblig.org,
        lucas.demarchi@intel.com, marcin.s.wojtas@gmail.com,
        ming.li@zohomail.com, mingo@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, niecheng1@uniontech.com,
        oleksandr_tyshchenko@epam.com, pabeni@redhat.com, pbonzini@redhat.com,
        quic_ramess@quicinc.com, ragazenta@gmail.com, rodrigo.vivi@intel.com,
        seanjc@google.com, shenlichuan@vivo.com, simona@ffwll.ch,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com,
        x86@kernel.org, xen-devel@lists.xenproject.org, yujiaoliang@vivo.com,
        zhanjun@uniontech.com
Subject: Re: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
User-Agent: K-9 Mail for Android
In-Reply-To: <2025072252-halves-sadness-18dc@gregkh>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com> <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com> <2025071607-outbid-heat-b0ba@gregkh> <634BA467821D37FE+0b2ace38-07d9-4500-8bb7-5a4fa65c4b9f@uniontech.com> <2025072252-halves-sadness-18dc@gregkh>
Message-ID: <10127165-7020-4D35-B0F3-099F58B2AF4E@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On July 22, 2025 12:57:33 AM PDT, Greg KH <gregkh@linuxfoundation=2Eorg> wr=
ote:
>On Tue, Jul 22, 2025 at 03:22:18PM +0800, WangYuli wrote:
>> Hi greg k-h,
>>=20
>> On 2025/7/16 16:08, Greg KH wrote:
>> > > Signed-off-by: WangYuli <wangyuli@uniontech=2Ecom>
>> > Is your name all one word like that, or should there be a " " between
>> > them?
>>=20
>> If I were to follow Western naming conventions, my name would be writte=
n as
>> 'Yuli Wang'=2E
>>=20
>> However, frankly, I find it unnecessary and can't be bothered to follow
>> their customs, unless a maintainer strongly insists=2E (For example, yo=
u can
>> see that my signature on commits for the LoongArch subsystem is differe=
nt
>> from my other contributions)=2E
>>=20
>> Since Chinese names are written without any spaces in Chinese character=
s, I
>> don't think it matters=2E
>
>Then use your Chinese name, don't feel like you need to change it to any
>other naming convention=2E  There's no requirement here at all to do so=
=2E
>
>thanks,
>
>greg k-h

To put it differently: what Greg (and the rest of us) want to make sure is=
 that your name appears the way you prefer=2E=20

Having the Latin transliteration in whatever form you prefer is greatly ap=
preciated, of course, since the knowledge of Chinese script is limited outs=
ide East Asia, but that's just about it=2E

If you want to add your name in proper Chinese script in addition that sho=
uld be fine, too=2E

