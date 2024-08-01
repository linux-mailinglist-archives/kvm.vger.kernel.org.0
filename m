Return-Path: <kvm+bounces-22955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5931944F15
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1ECD2B24583
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F3113CF8C;
	Thu,  1 Aug 2024 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rvj+s2M4"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929113B5AC;
	Thu,  1 Aug 2024 15:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525771; cv=none; b=kKbyG0pGbHpUUcQ4fdd2uikpmXlEUYUgjGoOrzn79waXoYaBUUMHh/8ZhOF+JaaIfo88j0EZcRzD4PiPyNarQ4IYcOI7nwLcDshnQpOIbdunM8GJl0kvc/1Grfc5dzmBuY5gNQqUhS1HmXCfVSbr2fPNgOug5lPYmqB4yyt0eoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525771; c=relaxed/simple;
	bh=MoAwAP99XKXHT49XS0io/ShWTU2wbYLn6ux3Xettcro=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L9lX+0SiNTcQLGG0E7F8c3UgcBY8P8y5I8Kc5XIFmhfyPNvBlXdn4Kx/T5gIKU9Ut9nqkajvOu0/mxOPt9sMplKVfePEuX/Wdmlf4Cng7BZuQseEkEYdlxmlLkPvz+9XLh7EsOCGmGNWxQTgZzbDlYmAquhVg4YUVs2oYKh57CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rvj+s2M4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mj8h/k1s5zEM80u6Ti/vtwMW86BbLVDkXUKONBwaWAQ=; b=rvj+s2M4QVsGGcQrx8zHEIXaFx
	0RgiauZgWnnsqtkPb7DFglZaW2W9hSH7flAPoEivc+B1Bg7yd6tzcvBcdlxsXpaXfEi2UPUWFqb57
	j645qETPpeK1kZx7klmOFTtK6/JIodWQbMwFEosOZzTlnqw1/EyxSaUyix0lFvq7tq+cXapxUq91e
	rZUf6n4EnWMWHimUk1TsZp+b2ADdjcHesjUXAYI2N0YhBH0skvuppOBVnEKCXsA3NiucTUMzG6C/8
	FosxHBZqyooEletK6J2Y60Jc2zNBSD0ZA3COg1WoJQj+gn+n4l0wWwiJTESq4TAKE+LGw1E+vbTlI
	ACX1bVEg==;
Received: from [2001:8b0:10b:5:9c27:6796:c1af:9131] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZXdU-000000000AK-2Uwk;
	Thu, 01 Aug 2024 15:22:36 +0000
Message-ID: <4bac07dc91de1c45720f36ed6b797d3f215f131a.camel@infradead.org>
Subject: Re: [PATCH] clockevents/drivers/i8253: Do not zero timer counter in
 shutdown
From: David Woodhouse <dwmw2@infradead.org>
To: mikelley@microsoft.com, kvm <kvm@vger.kernel.org>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, decui@microsoft.com, 
	haiyangz@microsoft.com, kys@microsoft.com, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lirongqing@baidu.com, mingo@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, wei.liu@kernel.org, x86@kernel.org
Date: Thu, 01 Aug 2024 16:22:35 +0100
In-Reply-To: <8eb7ba99a746110597bbac6f1e027aa63384dfce.camel@infradead.org>
References: <8eb7ba99a746110597bbac6f1e027aa63384dfce.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-7AO6vW62NRJyzdN58Qjk"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-7AO6vW62NRJyzdN58Qjk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2024-08-01 at 10:00 +0100, David Woodhouse wrote:
> >=20
> >=20
> >=20
> > On 2023-02-08 at 01:04:19 +0000, "Michael Kelley (LINUX)" <mikelley@mic=
rosoft.com> said:
> > > > From: lirongqing@baidu.com=C2=A0<lirongqing@baidu.com> Sent: Monday=
, February 6, 2023 5:15 PM
> > > > > >=20
> > > > > > Zeroing the counter register in pit_shutdown() isn't actually s=
upposed to
> > > > > > stop it from counting,=C2=A0 will causes the PIT to start runni=
ng again,
> > > > > > From the spec:
> > > > > >=20
> > > > > > =C2=A0 The largest possible initial count is 0; this is equival=
ent to 216 for
> > > > > > =C2=A0 binary counting and 104 for BCD counting.
> > > > > >=20
> > > > > > =C2=A0 The Counter does not stop when it reaches zero. In Modes=
 0, 1, 4, and 5 the
> > > > > > =C2=A0 Counter "wraps around" to the highest count, either FFFF=
 hex for binary
> > > > > > =C2=A0 count- ing or 9999 for BCD counting, and continues count=
ing.
> > > > > >=20
> > > > > > =C2=A0 Mode 0 is typically used for event counting. After the C=
ontrol Word is
> > > > > > =C2=A0 written, OUT is initially low, and will remain low until=
 the Counter
> > > > > > =C2=A0 reaches zero. OUT then goes high and remains high until =
a new count or a
> > > > > > =C2=A0 new Mode 0 Control Word is written into the Counter.
> > > > > >=20
> > > > > > Hyper-V and KVM follow the spec, the issue that 35b69a42 "(cloc=
kevents/drivers/
> > > > > > i8253: Add support for PIT shutdown quirk") fixed is in i8253 d=
rivers, not Hyper-v,
> > > > > > so delete the zero timer counter register in shutdown, and dele=
te PIT shutdown
> > > > > > quirk for Hyper-v
> > > >=20
> > > > From the standpoint of Hyper-V, I'm good with this change.=C2=A0 Bu=
t there's a
> > > > risk that old hardware might not be compliant with the spec, and ne=
eds the
> > > > zero'ing for some reason. The experts in the x86 space will be in t=
he best
> > > > position to assess the risk.=C2=A0 At the time, the quirk approach =
was taken so
> > > > the change applied only to Hyper-V, and any such risk was avoided.
> > > >=20
> > > > For Hyper-V,
> > > > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> >=20
> > It's not entirely clear why we zero it at all. What was it supposed to
> > achieve?

Answering my own question here, it seems that *some* implementations
don't apply the mode change until the counter is subsequently written.

I think QEMU applies it immediately. But the KVM in-kernel one (and the
AWS Nitro Hypervisor) do not. So the interrupt doesn't shut up until
you write the counter.

I don't see any justification for writing the counter causing any more
than *one* further interrupt though, in single-shot mode. If that's
what Hyper-V does, that seems like a bug (which is worked around
already).

I do see the VMM wasting a bunch of time emulating a PIT IRQ that goes
nowhere, but that seems to be because the bootloader or BIOS turns it
on, and nothing in Linux ever turns it back *off* again unless it's
registered at boot and then pit_shutdown() is called when we switch to
something better.

I'll look at an optimisation in the VMM which can stop firing the timer
if the PIT IRQ is already masked or pending in the PIC and IOAPIC;
that's just a waste of steal time.

But the guest kernel should probably do something like this...

diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 2b7999a1a50a..d13fd793254e 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -8,6 +8,7 @@
 #include <linux/timex.h>
 #include <linux/i8253.h>
=20
+#include <asm/hypervisor.h>
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
@@ -39,8 +40,29 @@ static bool __init use_pit(void)
=20
 bool __init pit_timer_init(void)
 {
-	if (!use_pit())
+	if (!use_pit()) {
+		if (!hypervisor_is_type(X86_HYPER_NATIVE)) {
+			/*
+			 * Don't just ignore the PIT. Ensure it's stopped,
+			 * because VMMs otherwise steal CPU time just to
+			 * pointlessly waggle the (masked) IRQ.
+			 */
+			raw_spin_lock(&i8253_lock);
+			outb_p(0x30, PIT_MODE);
+
+			/*
+			 * It's not entirely clear from the datasheet, but some
+			 * virtual implementations don't stop until the counter
+			 * is actually written.
+			 */
+			if (i8253_clear_counter_on_shutdown) {
+				outb_p(0, PIT_CH0);
+				outb_p(0, PIT_CH0);
+			}
+			raw_spin_unlock(&i8253_lock);
+		}
 		return false;
+	}
=20
 	clockevent_i8253_init(true);
 	global_clock_event =3D &i8253_clockevent;
>=20



--=-7AO6vW62NRJyzdN58Qjk
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODAxMTUyMjM1WjAvBgkqhkiG9w0BCQQxIgQgRj9nAXQX
PaNfCkt+v9ICsETgCl8vxIp2misfI/Ph+u4wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgBQCyVwM3mo+/QBAmJ7PD0fqFooIf5s7+TB
yZ77mrrR40GaX5aOch7DjQSeYXjuCHFYYm7zD5EX+5ret4TkRle2afiejN/PlZEtKAGZNrbcaNQR
ayc07KXfb+GA4d58uHbEnnyrtc1tVaIlHQ9dcJaE8EYKtpgvRK5a8yuosgkcpbJc3hCpmjNzI57t
CIDmJZ1BnoIYFjdBXBoy9ARGOnjKmA/RLJ1TnS/hsncT0pPnVgyCtq1HZHz2WMqkmEpm++CvOJfw
Ef+QF8I4pz77JhJr8gQkP+/p+TEGOR/YMxLZKF/4ZT2nJ0JWuqNZRjGwcYF/8qm9mWfs3jQTxHLs
o1fEnk+7jP9+LTz0Iga3dVYJJxVFTSr1HpbA8UZcZjFCXHDnWgf2qJRFTpGZaUt83A1v9h16eMOO
JpIDdjgow/ZD0lbqct4yYhnOjUKPF3+jQWYqDSk3v4JTzHDBAGliBzPSfMOSFf4oLMgox8briwxr
HEknYC3CuWwqTKA3Yaum+86OZ2/JtRpvb/uPXfNMJpOg7rb6NAKgaP5Y3Em/mV/9cezaYgX33Xh5
Top8PQ00Hz6VGNTDsSSEEC/fN6Y5EQLKfHd//J6PYcYlEDPsaYhcG2c+zdpWUU8KbIZ6BnWS75W8
3yU7Rfre/29IlCl6jMp6+GGR9BPrj9XUJvcmbRzg3AAAAAAAAA==


--=-7AO6vW62NRJyzdN58Qjk--

