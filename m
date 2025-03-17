Return-Path: <kvm+bounces-41243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 147CDA65798
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E136179C12
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2232194A6C;
	Mon, 17 Mar 2025 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Tr3mAMVj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47417A2EC
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742227707; cv=none; b=gSel09FaJ+Cf6nY//T0409uajwTpFaPdN2QBoJJy32s5tzVQamVUrwowz0JAeOhjTkuiYPcabRcAtgfD97ghaBUd0vkMYapbxL+V9As+Xahn+Uz1lV39BlCQ2yWjravu0c4HFDPFE8Tqk+FjQcmrudZmejoqUTTg5gsybnZxJVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742227707; c=relaxed/simple;
	bh=mzbTl5nkQKFBnmZRI2ae2XnEho9KAwozFu9d7AODj48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpKG9Yy6V2apa0X+tsS+3XajRkBf52h+9MBV5b/EDFNrpHarKWkP8mi6l3uhMJl3XMFEC7ufZi057kxxddkfZkZjk8MNKxvfwJ65L7nQh4KpRtKajhKjew8RY+ZVUdBiKyxDIWmEn2Tdovsh7CysTifsuCwd7VW6P1DlNmHyXmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Tr3mAMVj; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2255003f4c6so78926475ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742227705; x=1742832505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mzbTl5nkQKFBnmZRI2ae2XnEho9KAwozFu9d7AODj48=;
        b=Tr3mAMVjTZZQyoVV3YjSZdeY0Uf0MfllxFo1FtTq6JAkNiaMJqPkFof4esrPzts8Uo
         ev4q+U2MEiLqirZ0lQZq/jmtHl/xphGpc410WrxSEYprLNQm3pSMGiLRhxlEJ/m1gfHX
         5dB7ud20UHZfRP/vfcly3abJAN/1ebpxWq027Uobn0MVXkcx1y4PXgiXzKVel374sdOn
         vCdyN3JS6RYy32eAeLFumxYxGL1yKGfg8HgfVhMgtoZxGGihRxg5VRrUJk77Z7gMMhZ8
         aQgs8RmAd5QahEleW7eUt9hZU/VHUU5/iZ4Ad2fAxM96A9VZJqjoQLv4mL1hqbPuNLvP
         ByOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742227705; x=1742832505;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzbTl5nkQKFBnmZRI2ae2XnEho9KAwozFu9d7AODj48=;
        b=aPVe+sTiRFyolh7ui1efy+GsgBUMMCcxf2Jh18M/2sQnL6yK1CFFjo7Ss+I3nkNuSL
         geNZTKaO8PVSdwt/AhQhD3CLqFG0rHRiiZEl6dUmmyTyh5OiJwH/mjD23uNgPLckBK3P
         vytOtslDoxond/F5RZSr1bXQKPOMYn52O0kmviOwNHQOxK2neQABroDC8B7gvkcLyTxS
         9UjW79WEmAd41RRkYza+Mh8BsccPHXLqHtQ0qmeKfY8y0DaeTjSK5QfAXSYsVmukcTwk
         XF1h+97eeGc4KdAXT/w82M53y/5A8gNov3WEnSohKLyk+DnHiIe3/scp/JXPFBp13lfu
         GVqw==
X-Forwarded-Encrypted: i=1; AJvYcCXEn/BInDubEID0j/Ny+eEOiFdbAy8GK1295/t+/rQAoM5GaDtanhaaztm+9uYSOYdJT5A=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd3BKwNSHpPc34aQxm3XmltOKONdjFxYd2KZKY0iKPCjx0iI6s
	6yBgMWbwoPdJjlT8rSe/FeHOpCVIHhp3N3fDxDKXoQjmXxGQ0MTQi5DN9gtdhVI=
X-Gm-Gg: ASbGncsLx2+eCbxEwFFA1slUyR2kry7P2P+FXS0aIuSjPgiSnjwIedsvfdjlRfAU7Cy
	KLE0yogc5cs3qLlwhbgby1HpGMgyygeTDpHvSHvoO9caBYEKoS/GpBbXFmUtIGrMhsHJVcsy7Xb
	G62fVLS4YvxR0cxCuOboZ1MCyTV5W8NWi6WOfwkGJ9j4a+g6o4SPYwKK8OKVHVDTfQFKeVS9Rot
	yLykVybKMU8mPqfuRznjBof7DUuxVjgb0iYEnILhNepEWRmnkPsCZ352DoOYLSdr/cCxQmMweKO
	+Wz0QpnMuYZjI40s8d71+J1Z/EMpYgascgz69BJN6EQfKoepwAbq++W+IA==
X-Google-Smtp-Source: AGHT+IF6KgkWQt4kB3+J3NVrqV33E3W11zYKhfEgS1LyTWV2K7KDq8lWeWA7BEGG4QAbFg5GBaiRXg==
X-Received: by 2002:a05:6a20:cf8a:b0:1f5:80a3:b006 with SMTP id adf61e73a8af0-1f5c1201c3fmr19005019637.21.1742227704759;
        Mon, 17 Mar 2025 09:08:24 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56ea7c718sm7406992a12.62.2025.03.17.09.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 09:08:24 -0700 (PDT)
Message-ID: <7430b4de-284b-46b9-b29d-f018d0639431@linaro.org>
Date: Mon, 17 Mar 2025 09:08:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/17] exec/memory.h: make devend_memop "target
 defines" agnostic
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-6-pierrick.bouvier@linaro.org>
 <d5e2aa98-5b9c-4521-927f-86585b7b2cfa@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <d5e2aa98-5b9c-4521-927f-86585b7b2cfa@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNy8yNSAwODo0OCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE0LzMvMjUgMTg6MzEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBXaWxsIGFsbG93
IHRvIG1ha2Ugc3lzdGVtL21lbW9yeS5jIGNvbW1vbiBsYXRlci4NCj4+DQo+PiBSZXZpZXdl
ZC1ieTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVy
QGxpbmFyby5vcmc+DQo+PiAtLS0NCj4+ICAgIGluY2x1ZGUvZXhlYy9tZW1vcnkuaCB8IDE2
ICsrKystLS0tLS0tLS0tLS0NCj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDEyIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2V4ZWMv
bWVtb3J5LmggYi9pbmNsdWRlL2V4ZWMvbWVtb3J5LmgNCj4+IGluZGV4IGRhMjFlOTE1MGI1
Li4wNjkwMjFhYzNmZiAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvZXhlYy9tZW1vcnkuaA0K
Pj4gKysrIGIvaW5jbHVkZS9leGVjL21lbW9yeS5oDQo+PiBAQCAtMzEzOCwyNSArMzEzOCwx
NyBAQCBhZGRyZXNzX3NwYWNlX3dyaXRlX2NhY2hlZChNZW1vcnlSZWdpb25DYWNoZSAqY2Fj
aGUsIGh3YWRkciBhZGRyLA0KPj4gICAgTWVtVHhSZXN1bHQgYWRkcmVzc19zcGFjZV9zZXQo
QWRkcmVzc1NwYWNlICphcywgaHdhZGRyIGFkZHIsDQo+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB1aW50OF90IGMsIGh3YWRkciBsZW4sIE1lbVR4QXR0cnMgYXR0cnMp
Ow0KPj4gICAgDQo+PiAtI2lmZGVmIENPTVBJTElOR19QRVJfVEFSR0VUDQo+PiAgICAvKiBl
bnVtIGRldmljZV9lbmRpYW4gdG8gTWVtT3AuICAqLw0KPj4gICAgc3RhdGljIGlubGluZSBN
ZW1PcCBkZXZlbmRfbWVtb3AoZW51bSBkZXZpY2VfZW5kaWFuIGVuZCkNCj4+ICAgIHsNCj4+
ICAgICAgICBRRU1VX0JVSUxEX0JVR19PTihERVZJQ0VfSE9TVF9FTkRJQU4gIT0gREVWSUNF
X0xJVFRMRV9FTkRJQU4gJiYNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICBERVZJQ0Vf
SE9TVF9FTkRJQU4gIT0gREVWSUNFX0JJR19FTkRJQU4pOw0KPj4gICAgDQo+PiAtI2lmIEhP
U1RfQklHX0VORElBTiAhPSBUQVJHRVRfQklHX0VORElBTg0KPj4gLSAgICAvKiBTd2FwIGlm
IG5vbi1ob3N0IGVuZGlhbm5lc3Mgb3IgbmF0aXZlICh0YXJnZXQpIGVuZGlhbm5lc3MgKi8N
Cj4+IC0gICAgcmV0dXJuIChlbmQgPT0gREVWSUNFX0hPU1RfRU5ESUFOKSA/IDAgOiBNT19C
U1dBUDsNCj4+IC0jZWxzZQ0KPj4gLSAgICBjb25zdCBpbnQgbm9uX2hvc3RfZW5kaWFubmVz
cyA9DQo+PiAtICAgICAgICBERVZJQ0VfTElUVExFX0VORElBTiBeIERFVklDRV9CSUdfRU5E
SUFOIF4gREVWSUNFX0hPU1RfRU5ESUFOOw0KPj4gLQ0KPj4gLSAgICAvKiBJbiB0aGlzIGNh
c2UsIG5hdGl2ZSAodGFyZ2V0KSBlbmRpYW5uZXNzIG5lZWRzIG5vIHN3YXAuICAqLw0KPj4g
LSAgICByZXR1cm4gKGVuZCA9PSBub25faG9zdF9lbmRpYW5uZXNzKSA/IE1PX0JTV0FQIDog
MDsNCj4+IC0jZW5kaWYNCj4+ICsgICAgYm9vbCBiaWdfZW5kaWFuID0gKGVuZCA9PSBERVZJ
Q0VfTkFUSVZFX0VORElBTg0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgPyB0YXJnZXRf
d29yZHNfYmlnZW5kaWFuKCkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIDogZW5kID09
IERFVklDRV9CSUdfRU5ESUFOKTsNCj4gDQo+IFVubmVjZXNzYXJ5IHBhcmVudGhlc2lzPw0K
PiANCg0KTm90IHN0cmljdGx5IG5lZWRlZCBpbmRlZWQuDQpDb2RlIGlzIHJlZmFjdG9yZWQg
aW4gcGF0Y2ggMTQgYW55d2F5cy4NCg0KPj4gKyAgICByZXR1cm4gYmlnX2VuZGlhbiA/IE1P
X0JFIDogTU9fTEU7DQo+PiAgICB9DQo+PiAtI2VuZGlmIC8qIENPTVBJTElOR19QRVJfVEFS
R0VUICovDQo+PiAgICANCj4+ICAgIC8qDQo+PiAgICAgKiBJbmhpYml0IHRlY2hub2xvZ2ll
cyB0aGF0IHJlcXVpcmUgZGlzY2FyZGluZyBvZiBwYWdlcyBpbiBSQU0gYmxvY2tzLCBlLmcu
LA0KPiANCg0K

