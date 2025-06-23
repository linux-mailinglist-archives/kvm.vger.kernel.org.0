Return-Path: <kvm+bounces-50388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD24BAE4B1F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C230169545
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA7829C32C;
	Mon, 23 Jun 2025 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DeAvAroR"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BF9246BCD;
	Mon, 23 Jun 2025 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750696735; cv=none; b=GrRVucCiT2C+9CMuGeVyPg997V6EMgV5E8z2KKQ5v0lSx6qw2GM50gkno4EYIfB+K5kAM48ucZ3jLqV98OprzSl9/Nab+UWtmHw5OwGUwRWLRLpftFdxc7hofkO6FC60QJ2lmvEmDO2hiyzJKabfZrC+SGk181Gkqy81mHEAokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750696735; c=relaxed/simple;
	bh=gevdFq1xRrwPJ5Hf5ON4vbO7LUOLz1CD+kgUCJd+b4U=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bta53HFzhoP3ChjhBreWO6YRumtQMaNybu0uykSJzhDN9KjauLyb38Gx5tXhwIfCKURNmJVd/+VL35FLDhjwqEL/XS0M4tpWbSAX3z3nlubPugqhtLhSFDOMEGCWESwSa4HPlcf9dXfQ6EWbJPqHcHr9zuw6ycV+mp2UP/HPiRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DeAvAroR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ISEgUz1Ma4kDoDIXA+iw932nmvcNDPWKUXymSLJ53/I=; b=DeAvAroRgUlnTlLnAXqzYYurCq
	ULE8oUUf7dKlCyYvZ4hRYaH8O40Ko3w/GJ31Y9tFZevSLd/Wgf2DC9mne3n5uLa/g3JbVDKvu5bTg
	NvS2ZAlh5RnzM7/F6V1duuPo67mk88gjyIwAHKtsFa+LUOy/xMvw0MfjpAuKwiJXuwCzNhMkc5DiG
	iu5d1tIMwfG5x/aK1MIPtKEJlyKM7Bf1z0hPB4J71s2xxFcynKdbG8tr7NS1nW0H1NdwsaHlWh1cv
	4ORY/oeaTUGGEXIrV4naallt0p5XFX0dh4lnJukD428a/mK739FUxRHi0KGh5sAT9vK55J/grskQp
	uyutwvlQ==;
Received: from [54.239.6.189] (helo=edge-cache-144.e-fra50.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uTkC0-000000041IQ-0oCh;
	Mon, 23 Jun 2025 16:38:48 +0000
Message-ID: <c142f447c59861f3c94b0fea7f055f4ff201fa98.camel@infradead.org>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: vgic-its: Unmap all vPEs on shutdown
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Sebastian Ott <sebott@redhat.com>, Andre Przywara
 <andre.przywara@arm.com>, Thorsten Blum <thorsten.blum@linux.dev>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>,
 linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 23 Jun 2025 18:38:46 +0200
In-Reply-To: <20250623132714.965474-2-dwmw2@infradead.org>
References: <20250623132714.965474-1-dwmw2@infradead.org>
	 <20250623132714.965474-2-dwmw2@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-/dxTOkkvRolpaTs5bH+A"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-/dxTOkkvRolpaTs5bH+A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-06-23 at 14:27 +0100, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> We observed systems going dark on kexec, due to corruption of the new
> kernel's text (and sometimes the initrd). This was eventually determined
> to be caused by the vLPI pending tables used by the GIC in the previous
> kernel, which were not being quiesced properly.

FWIW this is a previous hack we attempted which *didn't* work. (For
illustration only; ignore the syscore .kexec hook. We addressed that
differently in the end with
https://lore.kernel.org/kexec/20231213064004.2419447-1-jgowans@amazon.com/ =
)

At the point where the its_kexec() hook in this patch has completed, we
poisoned the (ex-) vLPI pending tables and then scanned for corruption
in them. We saw the same characteristic pattern of corruption which had
been breaking the next kernel after kexec: 32 bytes copied from offset
0 to offset 32 in a page, followed by bytes 0, 1, 32, 33, 34, 35 being
zeroed.

Adding a few milliseconds of sleep before the poisoning was enough to
make the problem go away. As is the patch which calls unmap_all_vpes()
=E2=88=80 kvm.

Of course, if the GIC were behind an IOMMU as all DMA-capable devices
should be, this might never have happened...

diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-com=
mon.h
index f407cce9ecaa..a4fde376d214 100644
--- a/drivers/irqchip/irq-gic-common.h
+++ b/drivers/irqchip/irq-gic-common.h
@@ -19,6 +19,12 @@ struct gic_quirk {
 	u32 mask;
 };
=20
+struct redist_region {
+	void __iomem		*redist_base;
+	phys_addr_t		phys_base;
+	bool			single_redist;
+};
+
 int gic_configure_irq(unsigned int irq, unsigned int type,
                        void __iomem *base, void (*sync_access)(void));
 void gic_dist_config(void __iomem *base, int gic_irqs,
@@ -33,4 +39,6 @@ void gic_enable_of_quirks(const struct device_node *np,
 #define RDIST_FLAGS_RD_TABLES_PREALLOCATED     (1 << 1)
 #define RDIST_FLAGS_FORCE_NON_SHAREABLE        (1 << 2)
=20
+int gic_iterate_rdists(int (*fn)(struct redist_region *, void __iomem *));
+
 #endif /* _IRQ_GIC_COMMON_H */
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-=
its.c
index 638f7eb033ad..d106b6ccca8b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4902,6 +4902,51 @@ static void its_enable_quirks(struct its_node *its)
 				     its_quirks, its);
 }
=20
+static int disable_vpes(struct redist_region *region, void __iomem *ptr)
+{
+	u64 typer;
+	u64 val;
+
+	typer =3D gic_read_typer(ptr + GICR_TYPER);
+
+	if (!((typer & GICR_TYPER_VLPIS) && (typer & GICR_TYPER_RVPEID)))
+		return 1;
+
+	/* Deactivate any present vPE */
+	its_clear_vpend_valid(ptr + SZ_128K, 0, GICR_VPENDBASER_PendingLast);
+
+	/* Mark the VPE table as invalid */
+	val =3D gicr_read_vpropbaser(ptr + SZ_128K + GICR_VPROPBASER);
+	val &=3D ~GICR_VPROPBASER_4_1_VALID;
+	gicr_write_vpropbaser(val, ptr + SZ_128K + GICR_VPROPBASER);
+
+	/* Disable next redistributor */
+	return 1;
+}
+
+static int its_kexec(void)
+{
+	int err =3D 0, err_return =3D 0;
+	struct its_node *its;
+
+	raw_spin_lock(&its_lock);
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		err =3D its_force_quiescent(its->base);
+		if (err) {
+			pr_err("ITS@%pa: failed to quiesce: %d\n",
+			       &its->phys_base, err);
+			err_return =3D -EBUSY;
+		}
+	}
+
+	gic_iterate_rdists(disable_vpes);
+
+	raw_spin_unlock(&its_lock);
+
+	return err_return;
+}
+
 static int its_save_disable(void)
 {
 	struct its_node *its;
@@ -5001,6 +5046,7 @@ static void its_restore_enable(void)
 static struct syscore_ops its_syscore_ops =3D {
 	.suspend =3D its_save_disable,
 	.resume =3D its_restore_enable,
+	.kexec =3D its_kexec,
 };
=20
 static void __init __iomem *its_map_one(struct resource *res, int *err)
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 50143de1791d..2014c5a75a6e 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -46,12 +46,6 @@
=20
 #define GIC_IRQ_TYPE_PARTITION	(GIC_IRQ_TYPE_LPI + 1)
=20
-struct redist_region {
-	void __iomem		*redist_base;
-	phys_addr_t		phys_base;
-	bool			single_redist;
-};
-
 struct gic_chip_data {
 	struct fwnode_handle	*fwnode;
 	phys_addr_t		dist_phys_base;
@@ -968,7 +962,7 @@ static void __init gic_dist_init(void)
 		gic_write_irouter(affinity, base + GICD_IROUTERnE + i * 8);
 }
=20
-static int gic_iterate_rdists(int (*fn)(struct redist_region *, void __iom=
em *))
+int gic_iterate_rdists(int (*fn)(struct redist_region *, void __iomem *))
 {
 	int ret =3D -ENODEV;
 	int i;


--=-/dxTOkkvRolpaTs5bH+A
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDYyMzE2Mzg0
NlowLwYJKoZIhvcNAQkEMSIEIBD5uGKXDuvccbiamtTp0MIQGOPO/lLsMh/Bt2dhmpeiMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAzMCj0sCJ6UDc
vEPBvA1zwRUma/rjGPpaWEt+f5jBVKBgGWqYEVwjtu+yjtpaU2KC5rT9lnf5yGBC10Mav6P350sB
a9WUHY/iXK66AWl84E67KGmCvbvsmCz2dH7VNGDSrzx8OTMh2ME7LOj8a0SE6MeNJmruk4CHhQPG
KF1zvUV6A7Iu6hyZBoLDIYHMOP0g3/Is7jouxMxJJYBT5a60q4vIL1RuFcSxVfhqoaBjYYwaW45c
f+bD/IqmufJlKDjKEF84IGt0LvsoGcrGPKmgMkEKsfqmSqu3uJj97UZuIW6AYw8uBDYluWAZ5KjA
4YlW+y2rdi8dMqSUTm6ZPvLwM9qxbge+fcHvLpqF76VDJ+z/wlQ13rSCkCSDy7o7jhFgOORriWid
iFuzC/vd/yZ0ED8WvtbmRAE/DjJWlup1eb+mpnsL44mhdmhw26n0VRY5tNSYnrQVlqIlHiVMEAhK
XCw3Vt3i0Ry6xjG3CQQhjomKxLa8zgeMwtsQEwMX9B3ij0Rw+RFT2iAg0z57b0/pfdbpAOvVsr+H
G4atmqxWDiUvrKhH4E1YLClZpRNBZ+LtRTqsZwAYQRKSLNSDXk9HPdmcgH9P1Ge7+x1RmXqP+WHv
jTyPNrRi/V6KEBT9LLsQxnE39dEkfQVBttrxdfz2QIcsdZKmHrkjK5G7AoLtRpMAAAAAAAA=


--=-/dxTOkkvRolpaTs5bH+A--

