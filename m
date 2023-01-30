Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCCB680ABC
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 11:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbjA3KZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 05:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjA3KZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 05:25:49 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1382194C;
        Mon, 30 Jan 2023 02:25:47 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id me3so30265905ejb.7;
        Mon, 30 Jan 2023 02:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IISRXT35hL8Uk1c2h/nwHJF+0TEA/1+4nZBpZMm/b5s=;
        b=R+gnOclGQyWIi4V7RvgdoTzdiI3YWIq06BvfAQWiYrQp4LoIkcyzR7LNfHCVKSW5w+
         ReyRGX1MLikDw6a2BK2LBCuxudli8CghD1T9VuMz7FKzzlp1Ura2v+AsvQzh6UeZs6Cu
         JS3Qmm0lX80vn0cJauwA+HlFZXij9+oVX1z6sj8M3WNkIypQaJg+8xB8mCh9rdlRPQTC
         hCZG4YiQU9klUH6jE2EibjWizjFZj1AvIHvsQ+y6YXR8RLbIZnGhypRYhGhPLDRevVNe
         h1EqgmrxkDC9vCMCe4Ng8GGnblYRK8X3B5MdWVUyXJVGiQf+2M9vzg4ofKFug6/KScnu
         J9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IISRXT35hL8Uk1c2h/nwHJF+0TEA/1+4nZBpZMm/b5s=;
        b=YM5BI9oVDEOkyGYb4CTVxM6ZDO08qcU2bme5XuGUW46IwDw6H3ImD+SXOtTUCAYVB5
         p7H3+aTV2xqilokP1DUN8a/t1CHnB+yfT30pCk+O0dYg2qsUSWPb9G38TIazMA2HerRH
         rqweRUjc0xDYnSRaMm+aWfb99hrAOZLwcuvIJlyuo/2w20UFKvDdt5DckbnT2+ppXAa0
         M5Y2pVhzYx/o97yJDjumkfMqoErFA70zML/5KS8fc38U1B18Xlt+s44i1GkrYqpvHs92
         T6IJ52iJRhe8Qyx6cnRqWWAtve/i9KwozuBARV/JbWe2Ggr4ES9YixrAzu+kp6TX9UVl
         rM8g==
X-Gm-Message-State: AO0yUKWqGO9MU0b2mDC5Do4P980KoAwBF5qaMhjfG5Sk5x0BSSlNGDXc
        0hVMoDZQKVoKNadYQxk/7/w=
X-Google-Smtp-Source: AK7set8WEyoXWC1ejujb6qtnJthXNM85HbN3c8GTiV4H0n5Lv8g6RA7kbCfAYaL2xqik7vb+nQsJtg==
X-Received: by 2002:a17:906:b310:b0:878:52cd:9006 with SMTP id n16-20020a170906b31000b0087852cd9006mr17419959ejz.69.1675074346242;
        Mon, 30 Jan 2023 02:25:46 -0800 (PST)
Received: from touko.myxoz.lan (90-224-45-44-no2390.tbcn.telia.com. [90.224.45.44])
        by smtp.gmail.com with ESMTPSA id fe15-20020a1709072a4f00b008845c668408sm3131547ejc.169.2023.01.30.02.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 02:25:45 -0800 (PST)
Message-ID: <357d5157e01ee4469ca38595e941971083a51212.camel@gmail.com>
Subject: Re: [PATCH] x86/debug: Fix stack recursion caused by DR7 accesses
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     x86@kernel.org, hpa@zytor.com,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Alexey Kardashevskiy <aik@amd.com>
Date:   Mon, 30 Jan 2023 11:25:44 +0100
In-Reply-To: <20230130093717.460-1-joro@8bytes.org>
References: <20230130093717.460-1-joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAxLTMwIGF0IDEwOjM3ICswMTAwLCBKb2VyZyBSb2VkZWwgd3JvdGU6Cj4g
RnJvbTogSm9lcmcgUm9lZGVsIDxqcm9lZGVsQHN1c2UuZGU+Cj4gCj4gSW4ga2VybmVscyBjb21w
aWxlZCB3aXRoIENPTkZJR19QQVJBVklSVD1uIHRoZSBjb21waWxlciByZS1vcmRlcnMgdGhlCj4g
RFI3IHJlYWQgaW4gZXhjX25taSgpIHRvIGhhcHBlbiBiZWZvcmUgdGhlIGNhbGwgdG8KPiBzZXZf
ZXNfaXN0X2VudGVyKCkuCj4gCj4gVGhpcyBpcyBwcm9ibGVtYXRpYyB3aGVuIHJ1bm5pbmcgYXMg
YW4gU0VWLUVTIGd1ZXN0IGJlY2F1c2UgaW4gdGhpcwo+IGVudmlyb25lbW50IHRoZSBEUjcgcmVh
ZCBtaWdodCBjYXVzZSBhICNWQyBleGNlcHRpb24sIGFuZCB0YWtpbmcgI1ZDCj4gZXhjZXB0aW9u
cyBpcyBub3Qgc2FmZSBpbiBleGNfbm1pKCkgYmVmb3JlIHNldl9lc19pc3RfZW50ZXIoKSBoYXMK
PiBydW4uCj4gCj4gVGhlIHJlc3VsdCBpcyBzdGFjayByZWN1cnNpb24gaWYgdGhlIE5NSSB3YXMg
Y2F1c2VkIG9uIHRoZSAjVkMgSVNUCj4gc3RhY2ssIGJlY2F1c2UgYSBzdWJzZXF1ZW50ICNWQyBl
eGNlcHRpb24gaW4gdGhlIE5NSSBoYW5kbGVyIHdpbGwKPiBvdmVyd3JpdGUgdGhlIHN0YWNrIGZy
YW1lIG9mIHRoZSBpbnRlcnJ1cHRlZCAjVkMgaGFuZGxlci4KPiAKPiBBcyB0aGVyZSBhcmUgbm8g
Y29tcGlsZXIgYmFycmllcnMgYWZmZWN0aW5nIHRoZSBvcmRlcmluZyBvZiBEUjcKPiByZWFkcy93
cml0ZXMsIG1ha2UgdGhlIGFjY2Vzc2VzIHRvIHRoaXMgcmVnaXN0ZXIgdm9sYXRpbGUsIGZvcmJp
ZGRpbmcKPiB0aGUgY29tcGlsZXIgdG8gcmUtb3JkZXIgdGhlbS4KPiAKPiBDYzogQWxleGV5IEth
cmRhc2hldnNraXkgPGFpa0BhbWQuY29tPgo+IENjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGlu
ZnJhZGVhZC5vcmc+Cj4gU2lnbmVkLW9mZi1ieTogSm9lcmcgUm9lZGVsIDxqcm9lZGVsQHN1c2Uu
ZGU+Cj4gLS0tCj4gwqBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9kZWJ1Z3JlZy5oIHwgMjkgKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9kZWJ1Z3JlZy5oCj4gYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9kZWJ1Z3JlZy5oCj4gaW5kZXgg
YjA0OWQ5NTA2MTJmLi5lYjYyMzhhNWY2MGMgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vZGVidWdyZWcuaAo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2RlYnVncmVnLmgK
PiBAQCAtMzksNyArMzksMTggQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB1bnNpZ25lZCBsb25n
Cj4gbmF0aXZlX2dldF9kZWJ1Z3JlZyhpbnQgcmVnbm8pCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBhc20oIm1vdiAlJWRiNiwgJTAiIDoiPXIiICh2YWwpKTsKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+IMKgwqDCoMKgwqDCoMKgwqBjYXNlIDc6Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzbSgibW92ICUlZGI3LCAlMCIgOiI9ciIg
KHZhbCkpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBNYWtlIERSNyByZWFkcyB2b2xhdGlsZSB0byBmb3JiaWQg
cmUtb3JkZXJpbmcgdGhlbQo+IHdpdGggb3RoZXIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICogY29kZS4gVGhpcyBpcyBuZWVkZWQgYmVjYXVzZSBhIERSNyBhY2Nlc3MgY2FuCj4g
Y2F1c2UgYSAjVkMKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogZXhjZXB0aW9u
IHdoZW4gcnVubmluZyB1bmRlciBTRVYtRVMuIEJ1dCB0YWtpbmcgYQo+ICNWQwo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBleGNlcHRpb24gaXMgbm90IHNhZmUgYXQgZXZlcnl3
aGVyZSBpbiB0aGUgY29kZS0KPiBmbG93IGFuZAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKiByZS1vcmRlcmluZyBtaWdodCBwbGFjZSB0aGUgYWNjZXNzIGludG8gYW4gdW5zYWZl
Cj4gcGxhY2UuCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFRoaXMgaGFwcGVuZWQgaW4gdGhlIE5NSSBoYW5kbGVy
LCB3aGVyZSB0aGUgRFI3Cj4gcmVhZCB3YXMKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICogcmUtb3JkZXJlZCB0byBoYXBwZW4gYmVmb3JlIHRoZSBjYWxsIHRvCj4gc2V2X2VzX2lz
dF9lbnRlcigpLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBjYXVzaW5nIHN0
YWNrIHJlY3Vyc2lvbi4KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzbSB2b2xhdGlsZSAoIm1vdiAlJWRiNywgJTAi
IDogIj1yIiAodmFsKSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBicmVhazsK
PiDCoMKgwqDCoMKgwqDCoMKgZGVmYXVsdDoKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoEJVRygpOwo+IEBAIC02Niw3ICs3NywyMSBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZv
aWQKPiBuYXRpdmVfc2V0X2RlYnVncmVnKGludCByZWdubywgdW5zaWduZWQgbG9uZyB2YWx1ZSkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFzbSgibW92ICUwLCAlJWRiNiLCoMKg
wqDCoMKgOjoiciIgKHZhbHVlKSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBi
cmVhazsKPiDCoMKgwqDCoMKgwqDCoMKgY2FzZSA3Ogo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBhc20oIm1vdiAlMCwgJSVkYjciwqDCoMKgwqDCoDo6InIiICh2YWx1ZSkpOwo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKiBNYWtlIERSNyB3cml0ZXMgdm9sYXRpbGUgdG8gZm9yYmlkIHJlLW9yZGVyaW5n
Cj4gdGhlbSB3aXRoCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIG90aGVyIGNv
ZGUuIFRoaXMgaXMgbmVlZGVkIGJlY2F1c2UgYSBEUjcgYWNjZXNzCj4gY2FuIGNhdXNlIGEKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogI1ZDIGV4Y2VwdGlvbiB3aGVuIHJ1bm5p
bmcgdW5kZXIgU0VWLUVTLsKgIEJ1dAo+IHRha2luZyBhICNWQwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBleGNlcHRpb24gaXMgbm90IHNhZmUgYXQgZXZlcnl3aGVyZSBpbiB0
aGUgY29kZS0KPiBmbG93IGFuZAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBy
ZS1vcmRlcmluZyBtaWdodCBwbGFjZSB0aGUgYWNjZXNzIGludG8gYW4gdW5zYWZlCj4gcGxhY2Uu
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIFRoaXMgaGFwcGVuZWQgaW4gdGhlIE5NSSBoYW5kbGVyLCB3aGVyZSB0
aGUgRFI3Cj4gcmVhZCB3YXMKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogcmUt
b3JkZXJlZCB0byBoYXBwZW4gYmVmb3JlIHRoZSBjYWxsIHRvCj4gc2V2X2VzX2lzdF9lbnRlcigp
LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBjYXVzaW5nIHN0YWNrIHJlY3Vy
c2lvbi4KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICoKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgICogV2hpbGUgaXMgZGlkbid0IGhhcHBlbiB3aXRoIGEgRFI3IHdy
aXRlLCBhZGQgdGhlCj4gdm9sYXRpbGUKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICogaGVyZSB0b28gdG8gYXZvaWQgc2ltaWxhciBwcm9ibGVtcyBpbiB0aGUgZnV0dXJlLgo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgYXNtIHZvbGF0aWxlICgibW92ICUwLCAlJWRiNyLCoMKgwqA6OiJyIiAodmFsdWUp
KTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+IMKgwqDCoMKgwqDC
oMKgwqBkZWZhdWx0Ogo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgQlVHKCk7CgpU
aGlzIHNob3VsZCBwcm9iYWJseSBiZSBDYydlZCB0byB0aGUgc3RhYmxlIG1haWxpbmcgbGlzdC4K
LS0gCn5taWtvCg==

