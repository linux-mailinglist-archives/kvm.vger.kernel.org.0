Return-Path: <kvm+bounces-27101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C406997C191
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 23:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82531283731
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 21:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71BF1CB320;
	Wed, 18 Sep 2024 21:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="stRrEYQq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908118A6C5
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726696113; cv=none; b=egyFKEF39cu+QznMOqKvNhieW7m8jMvsUAC5GV6MvCux+ypTekLRtF+CniFJxgtrGTUB5t0YAK9CHbm0Z3Ugfc3eL3/yRyaTo/xctW7Ic8GMshReuJV+/8ESYD5ZGYLV+e+vwOAe6lMfWwGH2F1MMkzpvSLFOHMOE3mHZ+clrJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726696113; c=relaxed/simple;
	bh=56eFY0PPKbojN9iHiuO5E17taMmpX3hGYkXam5W4kI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPEpHP388EQixGNZhDGgnG/lujKHqirzERPZIcNPwPJ4iijosDCSiGWS5xqW32w/unMUPMFIMHW7V1TnliNxNAvRKaZKyi0D4p9arClER3F5R2sYrrcJs7SUX4b4/BEEK2b6wTBbSjhkNUtif5KwZohSJlzQJnziXbLwGZUjhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=stRrEYQq; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-205722ba00cso2087945ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 14:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726696110; x=1727300910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=56eFY0PPKbojN9iHiuO5E17taMmpX3hGYkXam5W4kI8=;
        b=stRrEYQqq2LQgAw8ntEQIsTai5CKS3BLXb70My4B3560YScd1oQe+A7bqe+dvfanQZ
         olbVEru9gAs940sllX57jqX8T9gxQijk/amR9cJzJ0YBllKE5g8+bw0BO2SnoO2yj7r1
         O7mysqohe1fcUL0vU4FA5iK+MLtfGyPJLyVvmCVnLhglBe1+IFHEjZJjwTYMmtaLEWb2
         9fdGVOrhqRmElxC2OCLBk9qL1+KqpmhgC1TZi7g3LCdgFxj1ABAadh3iu8uQjs6CATi1
         w3u1FWTlaeAXesR+ZXNd0YHserk0aq3EDUQ0GRg10U+iI15auQDQ30EKXIoeaTzSZ+QF
         XuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726696110; x=1727300910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56eFY0PPKbojN9iHiuO5E17taMmpX3hGYkXam5W4kI8=;
        b=mt+A72iWnIhW/MIGl/J3KKjk3H9zbZO2R0oI3J812iHCnqtSYfvW36URupZp7NGj0/
         Cmzp4gWQQlsaax8JnPH6CU2QGpsMOzuRWIlJ0Q8q3Dcc7AsnV00cbqEeEPOx5lNgV08Q
         BbLqXNZUAwUQROi/CT4mpcGH6zGGfPFkVTRcGxDOBV7wcWMn5rksZYimTRyixcKeiBTy
         7XmzgTQryQ9PxBv2UyHkuXZyonLpJWxDUB9gOZzWa1sh8L1Lor1uBM/gsu+EBpout0V4
         Uh/+g9dexXDfobue210E8mhHwpEgFT5/r08Gw1r8kpm3Zj5aDvP/bjvyvVSPQU8xC0QY
         3GOg==
X-Forwarded-Encrypted: i=1; AJvYcCV6namXjtVpJtCMVSq3zqT5fJ45Czg4gLO/YbYowAJitbQm2xF9h8GwdXpbXUq9dd2usKs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxedk8dmAkxU4zpewg6SsS8Bv89piJD/+P4zWn/9cs3C3+5rTVL
	csGqi1YoCaKeZxWSAXOYcdMlLeez0/YZ6OG1MENd1AuD6G4nmt4Uv7ft+psGu+0=
X-Google-Smtp-Source: AGHT+IG+xzYa/L8bq7kWZz9TpyKRRVs2FqZ8wnJP63m6mKS5eGogLn32uep1trP6iXzOGJjIS59+EQ==
X-Received: by 2002:a17:903:189:b0:205:500f:5dcc with SMTP id d9443c01a7336-2076e4612e7mr333975395ad.40.1726696109758;
        Wed, 18 Sep 2024 14:48:29 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20794735728sm69387345ad.271.2024.09.18.14.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 14:48:29 -0700 (PDT)
Message-ID: <fada9192-1f49-4ccc-a3e0-30f17459eb31@linaro.org>
Date: Wed, 18 Sep 2024 14:48:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/48] Use g_assert_not_reached instead of
 (g_)assert(0, false)
To: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Laurent Vivier <lvivier@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>,
 Halil Pasic <pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>,
 Michael Rolnik <mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Corey Minyard <minyard@acm.org>,
 Keith Busch <kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jesper Devantier <foss@defmacro.it>,
 Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
 Laurent Vivier <laurent@vivier.eu>,
 "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
 "Richard W.M. Jones" <rjones@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Hanna Reitz <hreitz@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>, Bin Meng <bmeng.cn@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Helge Deller <deller@gmx.de>,
 Peter Xu <peterx@redhat.com>, Daniel Henrique Barboza
 <danielhb413@gmail.com>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 Igor Mammedov <imammedo@redhat.com>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Eric Farman <farman@linux.ibm.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>,
 Eduardo Habkost <eduardo@habkost.net>,
 David Gibson <david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>,
 Weiwei Li <liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
 <OSZPR01MB6453486D937E15FBF6AEAD018D652@OSZPR01MB6453.jpnprd01.prod.outlook.com>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <OSZPR01MB6453486D937E15FBF6AEAD018D652@OSZPR01MB6453.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMi8yNCAxODozNywgWGluZ3RhbyBZYW8gKEZ1aml0c3UpIHdyb3RlOg0KPiANCj4g
DQo+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPj4gRnJvbTogcWVtdS1kZXZlbC1i
b3VuY2VzK3lhb3h0LmZuc3Q9ZnVqaXRzdS5jb21Abm9uZ251Lm9yZw0KPj4gPHFlbXUtZGV2
ZWwtYm91bmNlcyt5YW94dC5mbnN0PWZ1aml0c3UuY29tQG5vbmdudS5vcmc+IE9uIEJlaGFs
ZiBPZg0KPj4gUGllcnJpY2sgQm91dmllcg0KPj4gU2VudDogVGh1cnNkYXksIFNlcHRlbWJl
ciAxMiwgMjAyNCAzOjM5IFBNDQo+PiBUbzogcWVtdS1kZXZlbEBub25nbnUub3JnDQo+PiBD
YzogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT47IEFsZXggQmVubsOpZSA8YWxl
eC5iZW5uZWVAbGluYXJvLm9yZz47DQo+PiBMYXVyZW50IFZpdmllciA8bHZpdmllckByZWRo
YXQuY29tPjsgTWFyY2VsbyBUb3NhdHRpIDxtdG9zYXR0aUByZWRoYXQuY29tPjsNCj4+IE5p
Y2hvbGFzIFBpZ2dpbiA8bnBpZ2dpbkBnbWFpbC5jb20+OyBLbGF1cyBKZW5zZW4gPGl0c0Bp
cnJlbGV2YW50LmRrPjsgV0FORw0KPj4gWHVlcnVpIDxnaXRAeGVuMG4ubmFtZT47IEhhbGls
IFBhc2ljIDxwYXNpY0BsaW51eC5pYm0uY29tPjsgUm9iIEhlcnJpbmcNCj4+IDxyb2JoQGtl
cm5lbC5vcmc+OyBNaWNoYWVsIFJvbG5payA8bXJvbG5pa0BnbWFpbC5jb20+OyBaaGFvIExp
dQ0KPj4gPHpoYW8xLmxpdUBpbnRlbC5jb20+OyBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlk
ZWxsQGxpbmFyby5vcmc+OyBSaWNoYXJkDQo+PiBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVy
c29uQGxpbmFyby5vcmc+OyBGYWJpYW5vIFJvc2FzIDxmYXJvc2FzQHN1c2UuZGU+Ow0KPj4g
Q29yZXkgTWlueWFyZCA8bWlueWFyZEBhY20ub3JnPjsgS2VpdGggQnVzY2ggPGtidXNjaEBr
ZXJuZWwub3JnPjsgVGhvbWFzDQo+PiBIdXRoIDx0aHV0aEByZWRoYXQuY29tPjsgTWFjaWVq
IFMuIFN6bWlnaWVybyA8bWFjaWVqLnN6bWlnaWVyb0BvcmFjbGUuY29tPjsNCj4+IEhhcnNo
IFByYXRlZWsgQm9yYSA8aGFyc2hwYkBsaW51eC5pYm0uY29tPjsgS2V2aW4gV29sZiA8a3dv
bGZAcmVkaGF0LmNvbT47DQo+PiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29t
PjsgSmVzcGVyIERldmFudGllciA8Zm9zc0BkZWZtYWNyby5pdD47DQo+PiBIeW1hbiBIdWFu
ZyA8eW9uZy5odWFuZ0BzbWFydHguY29tPjsgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kNCj4+
IDxwaGlsbWRAbGluYXJvLm9yZz47IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAZGFiYmVsdC5j
b20+Ow0KPj4gcWVtdS1zMzkweEBub25nbnUub3JnOyBMYXVyZW50IFZpdmllciA8bGF1cmVu
dEB2aXZpZXIuZXU+Ow0KPj4gcWVtdS1yaXNjdkBub25nbnUub3JnOyBSaWNoYXJkIFcuTS4g
Sm9uZXMgPHJqb25lc0ByZWRoYXQuY29tPjsgTGl1IFpoaXdlaQ0KPj4gPHpoaXdlaV9saXVA
bGludXguYWxpYmFiYS5jb20+OyBBdXJlbGllbiBKYXJubyA8YXVyZWxpZW5AYXVyZWwzMi5u
ZXQ+OyBEYW5pZWwgUC4NCj4+IEJlcnJhbmfDqSA8YmVycmFuZ2VAcmVkaGF0LmNvbT47IE1h
cmNlbCBBcGZlbGJhdW0NCj4+IDxtYXJjZWwuYXBmZWxiYXVtQGdtYWlsLmNvbT47IGt2bUB2
Z2VyLmtlcm5lbC5vcmc7IENocmlzdGlhbiBCb3JudHJhZWdlcg0KPj4gPGJvcm50cmFlZ2Vy
QGxpbnV4LmlibS5jb20+OyBBa2loaWtvIE9kYWtpIDxha2loaWtvLm9kYWtpQGRheW5peC5j
b20+Ow0KPj4gRGFuaWVsIEhlbnJpcXVlIEJhcmJvemEgPGRiYXJib3phQHZlbnRhbmFtaWNy
by5jb20+OyBIYW5uYSBSZWl0eg0KPj4gPGhyZWl0ekByZWRoYXQuY29tPjsgQW5pIFNpbmhh
IDxhbmlzaW5oYUByZWRoYXQuY29tPjsNCj4+IHFlbXUtcHBjQG5vbmdudS5vcmc7IE1hcmMt
QW5kcsOpIEx1cmVhdSA8bWFyY2FuZHJlLmx1cmVhdUByZWRoYXQuY29tPjsNCj4+IEFsaXN0
YWlyIEZyYW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNvbT47IEJpbiBNZW5nIDxibWVu
Zy5jbkBnbWFpbC5jb20+Ow0KPj4gTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNv
bT47IEhlbGdlIERlbGxlciA8ZGVsbGVyQGdteC5kZT47IFBldGVyIFh1DQo+PiA8cGV0ZXJ4
QHJlZGhhdC5jb20+OyBEYW5pZWwgSGVucmlxdWUgQmFyYm96YSA8ZGFuaWVsaGI0MTNAZ21h
aWwuY29tPjsNCj4+IERtaXRyeSBGbGV5dG1hbiA8ZG1pdHJ5LmZsZXl0bWFuQGdtYWlsLmNv
bT47IE5pbmEgU2Nob2V0dGVybC1HbGF1c2NoDQo+PiA8bnNnQGxpbnV4LmlibS5jb20+OyBZ
YW5hbiBXYW5nIDx3YW5neWFuYW41NUBodWF3ZWkuY29tPjsNCj4+IHFlbXUtYXJtQG5vbmdu
dS5vcmc7IElnb3IgTWFtbWVkb3YgPGltYW1tZWRvQHJlZGhhdC5jb20+Ow0KPj4gSmVhbi1D
aHJpc3RvcGhlIER1Ym9pcyA8amNkQHRyaWJ1ZHVib2lzLm5ldD47IEVyaWMgRmFybWFuDQo+
PiA8ZmFybWFuQGxpbnV4LmlibS5jb20+OyBTcmlyYW0gWWFnbmFyYW1hbg0KPj4gPHNyaXJh
bS55YWduYXJhbWFuQGVyaWNzc29uLmNvbT47IHFlbXUtYmxvY2tAbm9uZ251Lm9yZzsgU3Rl
ZmFuIEJlcmdlcg0KPj4gPHN0ZWZhbmJAbGludXgudm5ldC5pYm0uY29tPjsgSm9lbCBTdGFu
bGV5IDxqb2VsQGptcy5pZC5hdT47IEVkdWFyZG8gSGFia29zdA0KPj4gPGVkdWFyZG9AaGFi
a29zdC5uZXQ+OyBEYXZpZCBHaWJzb24gPGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdT47
IEZhbQ0KPj4gWmhlbmcgPGZhbUBldXBob24ubmV0PjsgV2Vpd2VpIExpIDxsaXdlaTE1MThA
Z21haWwuY29tPjsgTWFya3VzDQo+PiBBcm1icnVzdGVyIDxhcm1icnVAcmVkaGF0LmNvbT47
IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+IFN1
YmplY3Q6IFtQQVRDSCB2MiAwMC80OF0gVXNlIGdfYXNzZXJ0X25vdF9yZWFjaGVkIGluc3Rl
YWQgb2YgKGdfKWFzc2VydCgwLA0KPj4gZmFsc2UpDQo+Pg0KPj4gVGhpcyBzZXJpZXMgY2xl
YW5zIHVwIGFsbCB1c2FnZXMgb2YgYXNzZXJ0L2dfYXNzZXJ0IHdobyBhcmUgc3VwcG9zZWQg
dG8gc3RvcA0KPj4gZXhlY3V0aW9uIG9mIFFFTVUuIFdlIHJlcGxhY2UgdGhvc2UgYnkgZ19h
c3NlcnRfbm90X3JlYWNoZWQoKS4NCj4+IEl0IHdhcyBzdWdnZXN0ZWQgcmVjZW50bHkgd2hl
biBjbGVhbmluZyBjb2RlYmFzZSB0byBidWlsZCBRRU1VIHdpdGggZ2NjDQo+PiBhbmQgdHNh
bjoNCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3FlbXUtZGV2ZWwvNTRiYjAyYTYtMWIx
Mi00NjBhLTk3ZjYtM2Y0NzhlZjc2NmM2QGxpbg0KPj4gYXJvLm9yZy8uDQo+Pg0KPj4gSW4g
bW9yZSwgY2xlYW51cCB1c2VsZXNzIGJyZWFrIGFuZCByZXR1cm4gYWZ0ZXIgZ19hc3NlcnRf
bm90X3JlYWNoZWQoKTsNCj4gSSBmb3VuZCB0aGF0IG5vdCBhbGwgb2YgdGhlIGJyZWFrIG9y
IHJldHVybiBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpIHdlcmUgY2xlYW5lZCB1cCwg
ZG9uJ3QgdGhleSBuZWVkIHRvIGJlIGNsZWFuZWQgdXA/DQo+Pg0KPj4gQW5kIGZpbmFsbHks
IGVuc3VyZSB3aXRoIHNjcmlwdHMvY2hlY2twYXRjaC5wbCB0aGF0IHdlIGRvbid0IHJlaW50
cm9kdWNlDQo+PiAoZ18pYXNzZXJ0KGZhbHNlKSBpbiB0aGUgZnV0dXJlLg0KPj4NCj4+IE5l
dyBjb21taXRzIChyZW1vdmluZyByZXR1cm4pIG5lZWQgcmV2aWV3Lg0KPj4NCj4+IFRlc3Rl
ZCB0aGF0IGl0IGJ1aWxkIHdhcm5pbmcgZnJlZSB3aXRoIGdjYyBhbmQgY2xhbmcuDQo+Pg0K
Pj4gdjINCj4+IC0gYWxpZ24gYmFja3NsYXNoZXMgZm9yIHNvbWUgY2hhbmdlcw0KPj4gLSBh
ZGQgc3VtbWFyeSBpbiBhbGwgY29tbWl0cyBtZXNzYWdlDQo+PiAtIHJlbW92ZSByZWR1bmRh
bnQgY29tbWVudA0KPj4NCj4+IHYxDQo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9xZW11
LWRldmVsLzIwMjQwOTEwMjIxNjA2LjE4MTc0NzgtMS1waWVycmljay5ib3V2aWVyQA0KPj4g
bGluYXJvLm9yZy9ULyN0DQo+Pg0KPj4gUGllcnJpY2sgQm91dmllciAoNDgpOg0KPj4gICAg
ZG9jcy9zcGluOiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVk
KCkNCj4+ICAgIGh3L2FjcGk6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90
X3JlYWNoZWQoKQ0KPj4gICAgaHcvYXJtOiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIGh3L2NoYXI6IHJlcGxhY2UgYXNzZXJ0KDApIHdp
dGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvY29yZTogcmVwbGFjZSBhc3Nl
cnQoMCkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBody9uZXQ6IHJlcGxh
Y2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvd2F0
Y2hkb2c6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0K
Pj4gICAgbWlncmF0aW9uOiByZXBsYWNlIGFzc2VydCgwKSB3aXRoIGdfYXNzZXJ0X25vdF9y
ZWFjaGVkKCkNCj4+ICAgIHFvYmplY3Q6IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3Nl
cnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgc3lzdGVtOiByZXBsYWNlIGFzc2VydCgwKSB3aXRo
IGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIHRhcmdldC9wcGM6IHJlcGxhY2UgYXNz
ZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgdGVzdHMvcXRlc3Q6
IHJlcGxhY2UgYXNzZXJ0KDApIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAg
dGVzdHMvdW5pdDogcmVwbGFjZSBhc3NlcnQoMCkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hl
ZCgpDQo+PiAgICBpbmNsdWRlL2h3L3MzOTB4OiByZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0
aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBibG9jazogcmVwbGFjZSBhc3NlcnQo
ZmFsc2UpIHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvaHlwZXJ2OiBy
ZXBsYWNlIGFzc2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAg
ICBody9uZXQ6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFj
aGVkKCkNCj4+ICAgIGh3L252bWU6IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIGh3L3BjaTogcmVwbGFjZSBhc3NlcnQoZmFsc2Up
IHdpdGggZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvcHBjOiByZXBsYWNlIGFz
c2VydChmYWxzZSkgd2l0aCBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBtaWdyYXRp
b246IHJlcGxhY2UgYXNzZXJ0KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkN
Cj4+ICAgIHRhcmdldC9pMzg2L2t2bTogcmVwbGFjZSBhc3NlcnQoZmFsc2UpIHdpdGggZ19h
c3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgdGVzdHMvcXRlc3Q6IHJlcGxhY2UgYXNzZXJ0
KGZhbHNlKSB3aXRoIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIGFjY2VsL3RjZzog
cmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIGJsb2Nr
OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcv
YWNwaTogcmVtb3ZlIGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAg
IGh3L2dwaW86IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+
PiAgICBody9taXNjOiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQo
KQ0KPj4gICAgaHcvbmV0OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNo
ZWQoKQ0KPj4gICAgaHcvcGNpLWhvc3Q6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9u
b3RfcmVhY2hlZCgpDQo+PiAgICBody9zY3NpOiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3Nl
cnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvdHBtOiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19h
c3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgdGFyZ2V0L2FybTogcmVtb3ZlIGJyZWFrIGFm
dGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIHRhcmdldC9yaXNjdjogcmVtb3Zl
IGJyZWFrIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIHRlc3RzL3F0ZXN0
OiByZW1vdmUgYnJlYWsgYWZ0ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgdWk6
IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBmcHU6
IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICB0Y2cv
bG9vbmdhcmNoNjQ6IHJlbW92ZSBicmVhayBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgp
DQo+PiAgICBpbmNsdWRlL3FlbXU6IHJlbW92ZSByZXR1cm4gYWZ0ZXIgZ19hc3NlcnRfbm90
X3JlYWNoZWQoKQ0KPj4gICAgaHcvaHlwZXJ2OiByZW1vdmUgcmV0dXJuIGFmdGVyIGdfYXNz
ZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIGh3L25ldDogcmVtb3ZlIHJldHVybiBhZnRlciBn
X2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBody9wY2k6IHJlbW92ZSByZXR1cm4gYWZ0
ZXIgZ19hc3NlcnRfbm90X3JlYWNoZWQoKQ0KPj4gICAgaHcvcHBjOiByZW1vdmUgcmV0dXJu
IGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIG1pZ3JhdGlvbjogcmVtb3Zl
IHJldHVybiBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICBxb2JqZWN0OiBy
ZW1vdmUgcmV0dXJuIGFmdGVyIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkNCj4+ICAgIHFvbTog
cmVtb3ZlIHJldHVybiBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+PiAgICB0ZXN0
cy9xdGVzdDogcmVtb3ZlIHJldHVybiBhZnRlciBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpDQo+
PiAgICBzY3JpcHRzL2NoZWNrcGF0Y2gucGw6IGVtaXQgZXJyb3Igd2hlbiB1c2luZyBhc3Nl
cnQoZmFsc2UpDQo+Pg0KPj4gICBkb2NzL3NwaW4vYWlvX25vdGlmeV9hY2NlcHQucHJvbWVs
YSAgICAgfCAgNiArKystLS0NCj4+ICAgZG9jcy9zcGluL2Fpb19ub3RpZnlfYnVnLnByb21l
bGEgICAgICAgIHwgIDYgKysrLS0tDQo+PiAgIGluY2x1ZGUvaHcvczM5MHgvY3B1LXRvcG9s
b2d5LmggICAgICAgICB8ICAyICstDQo+PiAgIGluY2x1ZGUvcWVtdS9wbWVtLmggICAgICAg
ICAgICAgICAgICAgICB8ICAxIC0NCj4+ICAgYWNjZWwvdGNnL3BsdWdpbi1nZW4uYyAgICAg
ICAgICAgICAgICAgIHwgIDEgLQ0KPj4gICBibG9jay9xY293Mi5jICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBibG9jay9zc2guYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMSAtDQo+PiAgIGh3L2FjcGkvYW1sLWJ1aWxkLmMgICAgICAgICAg
ICAgICAgICAgICB8ICAzICstLQ0KPj4gICBody9hcm0vaGlnaGJhbmsuYyAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBody9jaGFyL2F2cl91c2FydC5jICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBody9jb3JlL251bWEuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBody9ncGlvL25yZjUxX2dwaW8uYyAgICAgICAg
ICAgICAgICAgICAgfCAgMSAtDQo+PiAgIGh3L2h5cGVydi9oeXBlcnZfdGVzdGRldi5jICAg
ICAgICAgICAgICB8ICA3ICsrKy0tLS0NCj4+ICAgaHcvaHlwZXJ2L3ZtYnVzLmMgICAgICAg
ICAgICAgICAgICAgICAgIHwgMTUgKysrKysrLS0tLS0tLS0tDQo+PiAgIGh3L21pc2MvaW14
Nl9jY20uYyAgICAgICAgICAgICAgICAgICAgICB8ICAxIC0NCj4+ICAgaHcvbWlzYy9tYWNf
dmlhLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgLS0NCj4+ICAgaHcvbmV0L2UxMDAw
ZV9jb3JlLmMgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0tLQ0KPj4gICBody9uZXQvaTgy
NTk2LmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBody9uZXQvaWdi
X2NvcmUuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgNCArLS0tDQo+PiAgIGh3L25ldC9u
ZXRfcnhfcGt0LmMgICAgICAgICAgICAgICAgICAgICB8ICAzICstLQ0KPj4gICBody9uZXQv
dm14bmV0My5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSAtDQo+PiAgIGh3L252bWUv
Y3RybC5jICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA4ICsrKystLS0tDQo+PiAgIGh3
L3BjaS1ob3N0L2d0NjQxMjAuYyAgICAgICAgICAgICAgICAgICB8ICAyIC0tDQo+PiAgIGh3
L3BjaS9wY2ktc3R1Yi5jICAgICAgICAgICAgICAgICAgICAgICB8ICA2ICsrLS0tLQ0KPj4g
ICBody9wcGMvcHBjLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSAtDQo+PiAg
IGh3L3BwYy9zcGFwcl9ldmVudHMuYyAgICAgICAgICAgICAgICAgICB8ICAzICstLQ0KPj4g
ICBody9zY3NpL3ZpcnRpby1zY3NpLmMgICAgICAgICAgICAgICAgICAgfCAgMSAtDQo+PiAg
IGh3L3RwbS90cG1fc3BhcHIuYyAgICAgICAgICAgICAgICAgICAgICB8ICAxIC0NCj4+ICAg
aHcvd2F0Y2hkb2cvd2F0Y2hkb2cuYyAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4+ICAg
bWlncmF0aW9uL2RpcnR5cmF0ZS5jICAgICAgICAgICAgICAgICAgIHwgIDMgKy0tDQo+PiAg
IG1pZ3JhdGlvbi9taWdyYXRpb24taG1wLWNtZHMuYyAgICAgICAgICB8ICAyICstDQo+PiAg
IG1pZ3JhdGlvbi9wb3N0Y29weS1yYW0uYyAgICAgICAgICAgICAgICB8IDIxICsrKysrKyst
LS0tLS0tLS0tLS0tLQ0KPj4gICBtaWdyYXRpb24vcmFtLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgOCArKystLS0tLQ0KPj4gICBxb2JqZWN0L3FsaXQuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPj4gICBxb2JqZWN0L3FudW0uYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAxMiArKysrLS0tLS0tLS0NCj4+ICAgcW9tL29iamVjdC5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPj4gICBzeXN0ZW0vcnRjLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPj4gICB0YXJnZXQvYXJtL2h5cF9nZGJz
dHViLmMgICAgICAgICAgICAgICAgfCAgMSAtDQo+PiAgIHRhcmdldC9pMzg2L2t2bS9rdm0u
YyAgICAgICAgICAgICAgICAgICB8ICA0ICsrLS0NCj4+ICAgdGFyZ2V0L3BwYy9kZnBfaGVs
cGVyLmMgICAgICAgICAgICAgICAgIHwgIDggKysrKy0tLS0NCj4+ICAgdGFyZ2V0L3BwYy9t
bXVfaGVscGVyLmMgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4+ICAgdGFyZ2V0L3Jpc2N2
L21vbml0b3IuYyAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPj4gICB0ZXN0cy9xdGVzdC9h
Y3BpLXV0aWxzLmMgICAgICAgICAgICAgICAgfCAgMSAtDQo+PiAgIHRlc3RzL3F0ZXN0L2lw
bWktYnQtdGVzdC5jICAgICAgICAgICAgICB8ICAyICstDQo+PiAgIHRlc3RzL3F0ZXN0L2lw
bWkta2NzLXRlc3QuYyAgICAgICAgICAgICB8ICA0ICsrLS0NCj4+ICAgdGVzdHMvcXRlc3Qv
bWlncmF0aW9uLWhlbHBlcnMuYyAgICAgICAgIHwgIDEgLQ0KPj4gICB0ZXN0cy9xdGVzdC9u
dW1hLXRlc3QuYyAgICAgICAgICAgICAgICAgfCAxMCArKysrKy0tLS0tDQo+PiAgIHRlc3Rz
L3F0ZXN0L3J0bDgxMzktdGVzdC5jICAgICAgICAgICAgICB8ICAyICstDQo+PiAgIHRlc3Rz
L3VuaXQvdGVzdC14cy1ub2RlLmMgICAgICAgICAgICAgICB8ICA0ICsrLS0NCj4+ICAgdWkv
cWVtdS1waXhtYW4uYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPj4gICBmcHUv
c29mdGZsb2F0LXBhcnRzLmMuaW5jICAgICAgICAgICAgICAgfCAgMiAtLQ0KPj4gICB0YXJn
ZXQvcmlzY3YvaW5zbl90cmFucy90cmFuc19ydnYuYy5pbmMgfCAgMiAtLQ0KPj4gICB0Y2cv
bG9vbmdhcmNoNjQvdGNnLXRhcmdldC5jLmluYyAgICAgICAgfCAgMSAtDQo+PiAgIHNjcmlw
dHMvY2hlY2twYXRjaC5wbCAgICAgICAgICAgICAgICAgICB8ICAzICsrKw0KPj4gICA1NCBm
aWxlcyBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspLCAxMjAgZGVsZXRpb25zKC0pDQo+Pg0K
Pj4gLS0NCj4+IDIuMzkuMg0KPj4NCj4gDQoNCldoaWNoIG9uZSBkaWQgeW91IGZpbmQ/IFVz
aW5nIHdoaWNoIGdyZXAgY29tbWFuZD8NCg==

