Return-Path: <kvm+bounces-55382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4BCB3057A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B197A18907FF
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A22D33A015;
	Thu, 21 Aug 2025 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SBUt5/3f"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43CE3823AB;
	Thu, 21 Aug 2025 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806979; cv=none; b=Knf6+KA5YKRRgJGxhLjjitbyJSRY3BAM/NPFKdupB3EHuG/C0V5cU0NPw7FUdeZaE4POCianPh82/jBUQ3aGjcZFGUw+EZvK7w5rXlpRB9dBeakp5NhZ0FlUKjWSHJ3fRZJ+98vTDSQiLuacumYzwpSiIBLtBqz3wphzDDInzJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806979; c=relaxed/simple;
	bh=7HK4DjNLbjHq0pWnQ0dFHKUxTg8f18pjTAsGbF3W/s8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mM1VecKAs7Kmzw2AkhqKDd2VJZC1xu7/iV6iK6EY9ocbnjdTTAv2GHf5TwSLdM76GvgGYLRhdIQgz6yLVjOerA50jSPNX7tcCShxdXQf2KOueVCTOwmv36w/9qtjPcSlh+Bx9kZU6CWmm/+SWYO36SONU7YXOBgUwDENpYZrLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SBUt5/3f; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CgsKh6PQ2X7sbamc7uSGEeb01yrHIxNuVCtONrzWHJ4=; b=SBUt5/3fPfGOxjDH2W0WkNNlty
	lG5n7wiKp3WNjkgfokRxgNzX2PaVFggPxkUrCZ++JwrzldPBu8i8bgV3uKCyNTD5NnjahLz5/qp0c
	mO0Ax0VwMDeW9jNE/N5mZO4wHkWVmpH/DkBFZgSpJFB2rFAYCoT++BmvZ2aCuGHAU8c3XJVfwUnFb
	P/P3dtD7Ow26SexGKkPXbR7LvMGf96N8kkqfx6qvCGKhigdat8o1wWbNrNKpvYjjiA9OnjMBS6FqV
	/H8lfLguR7VVfAqVvKR16nBwEEQELBmpP+nsgUMUp5HHtxTZ9VfLD/7WDO4Wc7CUIDllJFCCLh4Bu
	ML5NPnhA==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=freeip.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upBb4-0000000D3Ny-06yh;
	Thu, 21 Aug 2025 20:09:18 +0000
Message-ID: <5b905902c99e13d65ea0810b0885fca97cffc74d.camel@infradead.org>
Subject: Re: [PATCH v3 13/15] x86/cpu/intel: Bound the non-architectural
 constant_tsc model checks
From: David Woodhouse <dwmw2@infradead.org>
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org, Dave Hansen
	 <dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>, 
 =?ISO-8859-1?Q?J=FCrgen?= Gross
	 <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel
	 <xen-devel@lists.xenproject.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>,  Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>,  Kan Liang <kan.liang@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, "H . Peter
 Anvin" <hpa@zytor.com>, "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown
 <lenb@kernel.org>, Andy Lutomirski <luto@kernel.org>, Viresh Kumar
 <viresh.kumar@linaro.org>, Jean Delvare <jdelvare@suse.com>, Guenter Roeck
 <linux@roeck-us.net>, Zhang Rui <rui.zhang@intel.com>, Andrew Cooper
 <andrew.cooper3@citrix.com>, David Laight <david.laight.linux@gmail.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,  linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-acpi@vger.kernel.org,
 linux-pm@vger.kernel.org, kvm@vger.kernel.org,  xiaoyao.li@intel.com, Xin
 Li <xin@zytor.com>
Date: Thu, 21 Aug 2025 21:09:16 +0100
In-Reply-To: <5f5f1230-f373-469c-b0d9-abc80199886e@intel.com>
References: <20250219184133.816753-1-sohil.mehta@intel.com>
	 <20250219184133.816753-14-sohil.mehta@intel.com>
	 <6f05a6849fb7b22db35216dcf12bf537f8a43a92.camel@infradead.org>
	 <968a179f-3da7-4c69-b798-357ea8d759eb@intel.com>
	 <5f5f1230-f373-469c-b0d9-abc80199886e@intel.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-OQYT5kBmShxkyhQquOGw"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-OQYT5kBmShxkyhQquOGw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-08-21 at 12:43 -0700, Sohil Mehta wrote:
> On 8/21/2025 12:34 PM, Sohil Mehta wrote:
> > On 8/21/2025 6:15 AM, David Woodhouse wrote:
> >=20
> > > Hm. My test host is INTEL_HASWELL_X (0x63f). For reasons which are
> > > unclear to me, QEMU doesn't set bit 8 of 0x80000007 EDX unless I
> > > explicitly append ',+invtsc' to the existing '-cpu host' on its comma=
nd
> > > line. So now my guest doesn't think it has X86_FEATURE_CONSTANT_TSC.
> > >=20
> >=20
> > Haswell should have X86_FEATURE_CONSTANT_TSC, so I would have expected
> > the guest bit to be set. Until now, X86_FEATURE_CONSTANT_TSC was set
> > based on the Family-model instead of the CPUID enumeration which may
> > have hid the issue.
> >=20
>=20
> Correction:
> s/instead/as well as
>=20
> > From my initial look at the QEMU implementation, this seems intentional=
.
> >=20
> > QEMU considers Invariant TSC as un-migratable which prevents it from
> > being exposed to migratable guests (default).
> > target/i386/cpu.c:
> > [FEAT_8000_0007_EDX]
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .unmigratable_flags =
=3D CPUID_APM_INVTSC,
> >=20
> > Can you please try '-cpu host,migratable=3Doff'?
>=20
> This is mainly to verify. If confirmed, I am not sure what the long term
> solution should be.

Yes, explicitly turning it on with -cpu host,+invtsc does work.

I've been looking into why it takes a Xen guest four seconds per vCPU
in this case, but not a KVM guest.

When running as a KVM guest, Linux will infer the TSC frequency from
the KVM clock =E2=80=94 or better still, from CPUID; see
https://lore.kernel.org/all/20250816101308.2594298-1-dwmw2@infradead.org
and/or
https://lore.kernel.org/all/20250227021855.3257188-36-seanjc@google.com

As a Xen guest though, Linux doesn't do that. This patch in the guest
should make it work without recalibrating the TSC for each vCPU...

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -489,7 +489,15 @@ static void xen_setup_vsyscall_time_info(void)
  */
 static int __init xen_tsc_safe_clocksource(void)
 {
-       u32 eax, ebx, ecx, edx;
+       u32 eax, ebx, ecx, edx;
+       u64 lpj;
+
+       /* Leaf 4, sub-leaf 0 (0x40000x03) */
+       cpuid_count(xen_cpuid_base() + 3, 0, &eax, &ebx, &ecx, &edx);
+
+       lpj =3D ((u64)ecx * 1000);
+       do_div(lpj, HZ);
+       preset_lpj =3D lpj;
=20
        if (!(boot_cpu_has(X86_FEATURE_CONSTANT_TSC)))
                return 0;
@@ -500,9 +508,6 @@ static int __init xen_tsc_safe_clocksource(void)
        if (check_tsc_unstable())
                return 0;
=20
-       /* Leaf 4, sub-leaf 0 (0x40000x03) */
-       cpuid_count(xen_cpuid_base() + 3, 0, &eax, &ebx, &ecx, &edx);
-
        return ebx =3D=3D XEN_CPUID_TSC_MODE_NEVER_EMULATE;
 }
=20

... but then I got slightly distracted by the question of why I was
getting *nonsense* in those values, and why KVM is 'correcting' EAX in
subleaf 2 which is supposed to be the *host* TSC, not ECX in subleaf
zero...

Under the Fedora 6.13.8-200 kernel I'm fairly sure the guest was seeing
values in subleaf 0 ECX/EDX that *should* have been in subleaf 1
ECX/EDX, and that problem went away when I rebooted the host into a
mainline kernel. Will have to go back and retest that part...

--=-OQYT5kBmShxkyhQquOGw
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgyMTIwMDkx
NlowLwYJKoZIhvcNAQkEMSIEIAG0b8QSR+4yVgfKGJpqXbAWAJsAGD9WcicVj0v2UrnXMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAYAQXjfrRF6Aw
wkpiAGwlYVrJMDq3pZmKkRo2O2oX9KsV+UEaSYYYl0R2Jh6oFZQuOc/MA/jL9S2L178LxZyr4D/b
XAoE5piPTdNFJs3zLrDWEjk40yIQLu7LGcPxTyH1FLGT6pzu9CVr9YEqwEJX8Mbp+fBI4dVWmMg7
ATVf6QBOkkHcXdYcd+jhU8nva6romlpgY8xuFJlkEogy1C+r7N8U4VP+eHNwGkDBVI7iszM68kq/
u8+Hj3FkpUconyKWZVCbcPC3W4XFM1cPkIbvUjoeZw4P/yIOwXWtOWR6gi6Q4iedRHdjR7GiPaaP
ob7gMTqMzyrC/Xtp9xypLdtnIgUQDnfjNrAft1c7QYuOtnWFgceL67Ag2vWOebxhfZCOblCzRwLN
jnDc5c0Zo6/RvoGu0SPhTnrxHkw4EjWES3V+3f7FNBZJPY8HrTjuLNJYl3+hI/cutjqR04UyDRHZ
4jGwFpXkjWq28MCWPVCdxzvU9CeJPlnzkqfR3C3WHSWu6r78l2jd/es3WAnbbuI44vVwpG2y/Eeb
+zLdmD1NXD1tPkx4CiYLXu3MvjLWQzYI17pFDNF+a7hJvfKA7g0urkca2QSa9E6Pq/B3bI/sGAaf
X4ZZUqqwCd8TRHVBgXrxXWfniABNpl6s7rUDTfMy0SQcUnMvw7miAmnGEqFkSVwAAAAAAAA=


--=-OQYT5kBmShxkyhQquOGw--

