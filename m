Return-Path: <kvm+bounces-60709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B4399BF8354
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 21:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 829984E6B21
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DA5350281;
	Tue, 21 Oct 2025 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="RT2ai21c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13EB34D934
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 19:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761074013; cv=none; b=Gka92VZx7dsabSyyZ8UC6MQ/niXC22pTvlBeBmUH/F2UrGfghox+IPPVhULPyC3uYeyVK33wWsYK2GpHHJJj1Y77g/8Cno1xu9c9IyDAWyhbJJyrdgV1VAvNIjzP/Ba18l6K5O2GOm/pduUw4zu/8lw/mxBvpI6SghorfC45rNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761074013; c=relaxed/simple;
	bh=9BGFqgvQpwRzugKQDwtv8oq6Y9R6QMH395rdLNU+/Ak=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNVOZRVcy2iLOZ0ecm0msRkLJC+V/sN7qRaXy61HVwFAQnvg5qVF0msVcMuMgHXjDO9cv2tH8DSopv6Xv6ifvQqbaH+NyBfvMGZTDKz2BqjJMBq+LBMUplV7ss6E+eKM5w8NXBA3H0+KODggx/9uRcL4ur2Om9IkjBLKgT/OVM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=RT2ai21c; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59LGE6X13453679
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 12:13:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=CRMDwFVND7XBdOIj4TyxKg+K8DJ1yTSK2JyyRAuwtnQ=; b=RT2ai21c21e4
	9Fdv+/ELtkFCdPgh7ynth4iQJClg6JQdm59hM8KaPNhAsVlrPkEri+sZ/56YNjJ2
	v4acHIAlqjrR/OBMLMllsItz1P0K+/JQOzz+QKkMby237Nsk74n9ikCm8wN/bNSN
	vtEP4FqsJ8kBD84fO1drnfNL3GN7a2KYHSyv6cUovdl8fv0ZJ/T3jvERp8JgtR92
	v6EkDr7lil6IvnJgvbqx7V53UJx2Tlac2k2RfJV+A5GU2BAOUQ6OAVxhisHMHts4
	g8xZVRSjJffpiboDFwOE4rLZl7Kn60TfnO5MZ3WNGL+lycdIEzyeh9zGCftrXg17
	9hwphWZJ0w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49xdh29txf-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 12:13:30 -0700 (PDT)
Received: from twshared42488.16.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 21 Oct 2025 19:13:28 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 23751)
	id 0C3C14EA2D6; Tue, 21 Oct 2025 12:13:23 -0700 (PDT)
Date: Tue, 21 Oct 2025 12:13:23 -0700
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aPfbU4rYkSUDG4D0@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
 <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org>
 <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org>
 <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
 <CALzav=ebeVvg5jyFjkAN-Ud==6xS9y1afszSE10mpa9PUOu+Dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CALzav=ebeVvg5jyFjkAN-Ud==6xS9y1afszSE10mpa9PUOu+Dw@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: 9V852XzaVnnC2Akf4GLxdD46vgZ5ItWq
X-Authority-Analysis: v=2.4 cv=RbGdyltv c=1 sm=1 tr=0 ts=68f7db5a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=XGgmd8J1ZICZxjAZIHAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIxMDE1MyBTYWx0ZWRfX8h/ne7rgT1Ic
 DLDZkgzkfPq7FZatF/C35894ZAIV8Dxyl6+7YBl9+kGxPrCXjleR/Qz2bzcfxX+EyZYh0MY7qzN
 uxKIyR0DTVSqaYn2NSJ7gOMbwG8W1bGfogTurRd9itIOKy5z1fkPLpZGk4HZuKcMqvK4fw7hSwc
 2BQ6BXMLOoOYXKSuzBdllS5Q6QmH1pZtI+x5G7SZadLaN95x2D4lsd5UCAIJjWO7obPxbINqPRd
 kHiEiTKp48gqqRLBRIlqmsd/CKSc6M8aREpXWCfLBGoRHMT29+V5PrGomHu7B5QGMTvg+eit4bM
 gDl6ShDnDPOTepl/i3OK9HCo/ttS+4qw7hfLDf6aWENVJqd2E7DejLz3Fv13Oc6DvlreR9fwHY8
 VgX5QFQcbnGGjyVfbkUbLKikpRpOew==
X-Proofpoint-GUID: 9V852XzaVnnC2Akf4GLxdD46vgZ5ItWq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_03,2025-10-13_01,2025-03-28_01

On Tue, Oct 21, 2025 at 09:31:59AM -0700, David Matlack wrote:
> On Tue, Oct 21, 2025 at 9:26=E2=80=AFAM Alex Mastro <amastro@fb.com> wr=
ote:
> > On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> > > Should we also therefore expand the DMA mapping tests in
> > > tools/testing/selftests/vfio to include an end of address space tes=
t?
> >
> > Yes. I will append such a commit to the end of the series in v5. Our =
VFIO tests
> > are built on top of a hermetic rust wrapper library over VFIO ioctls,=
 but they
> > aren't quite ready to be open sourced yet.
>=20
> Feel free to reach out if you have any questions about writing or
> running the VFIO selftests.

Thanks David. I built and ran using below. I am not too familiar with
kselftests, so open to tips.

$ make LLVM=3D1 -j kselftest-install INSTALL_PATH=3D/tmp/kst TARGETS=3D"v=
fio"
$ VFIO_SELFTESTS_BDF=3D0000:05:00.0 /tmp/kst/run_kselftest.sh

I added the following. Is this the right direction? Is multiple fixtures =
per
file OK? Seems related enough to vfio_dma_mapping_test.c to keep together=
.

I updated the *_unmap function signatures to return the count of bytes un=
mapped,
since that is part of the test pass criteria. Also added unmap_all flavor=
s,
since those exercise different code paths than range-based unmap.

Relevant test output:

# #  RUN           vfio_dma_map_limit_test.vfio_type1_iommu.end_of_addres=
s_space ...
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# #            OK  vfio_dma_map_limit_test.vfio_type1_iommu.end_of_addres=
s_space
# ok 16 vfio_dma_map_limit_test.vfio_type1_iommu.end_of_address_space
# #  RUN           vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_addr=
ess_space ...
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# #            OK  vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_addr=
ess_space
# ok 17 vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_address_space
# #  RUN           vfio_dma_map_limit_test.iommufd_compat_type1.end_of_ad=
dress_space ...
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# #            OK  vfio_dma_map_limit_test.iommufd_compat_type1.end_of_ad=
dress_space
# ok 18 vfio_dma_map_limit_test.iommufd_compat_type1.end_of_address_space
# #  RUN           vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_=
address_space ...
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# #            OK  vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_=
address_space
# ok 19 vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_address_spa=
ce
# #  RUN           vfio_dma_map_limit_test.iommufd.end_of_address_space .=
..
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
# Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools=
/testing/selftests/vfio/lib/include/vfio_util.h
index ed31606e01b7..8e9d40845ccc 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -208,8 +208,9 @@ void vfio_pci_device_reset(struct vfio_pci_device *de=
vice);
=20
 void vfio_pci_dma_map(struct vfio_pci_device *device,
 		      struct vfio_dma_region *region);
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
-			struct vfio_dma_region *region);
+u64 vfio_pci_dma_unmap(struct vfio_pci_device *device,
+                       struct vfio_dma_region *region);
+u64 vfio_pci_dma_unmap_all(struct vfio_pci_device *device);
=20
 void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
 			    size_t config, size_t size, void *data);
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/t=
esting/selftests/vfio/lib/vfio_pci_device.c
index 0921b2451ba5..f5ae68a7df9c 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -183,7 +183,7 @@ void vfio_pci_dma_map(struct vfio_pci_device *device,
 	list_add(&region->link, &device->dma_regions);
 }
=20
-static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
+static u64 vfio_iommu_dma_unmap(struct vfio_pci_device *device,
 				 struct vfio_dma_region *region)
 {
 	struct vfio_iommu_type1_dma_unmap args =3D {
@@ -193,9 +193,25 @@ static void vfio_iommu_dma_unmap(struct vfio_pci_dev=
ice *device,
 	};
=20
 	ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
+
+	return args.size;
+}
+
+static u64 vfio_iommu_dma_unmap_all(struct vfio_pci_device *device)
+{
+	struct vfio_iommu_type1_dma_unmap args =3D {
+		.argsz =3D sizeof(args),
+		.iova =3D 0,
+		.size =3D 0,
+		.flags =3D VFIO_DMA_UNMAP_FLAG_ALL,
+	};
+
+	ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
+
+	return args.size;
 }
=20
-static void iommufd_dma_unmap(struct vfio_pci_device *device,
+static u64 iommufd_dma_unmap(struct vfio_pci_device *device,
 			      struct vfio_dma_region *region)
 {
 	struct iommu_ioas_unmap args =3D {
@@ -206,17 +222,54 @@ static void iommufd_dma_unmap(struct vfio_pci_devic=
e *device,
 	};
=20
 	ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
+
+	return args.length;
+}
+
+static u64 iommufd_dma_unmap_all(struct vfio_pci_device *device)
+{
+	struct iommu_ioas_unmap args =3D {
+		.size =3D sizeof(args),
+		.iova =3D 0,
+		.length =3D UINT64_MAX,
+		.ioas_id =3D device->ioas_id,
+	};
+
+	ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
+
+	return args.length;
 }
=20
-void vfio_pci_dma_unmap(struct vfio_pci_device *device,
+u64 vfio_pci_dma_unmap(struct vfio_pci_device *device,
 			struct vfio_dma_region *region)
 {
+	u64 unmapped;
+
 	if (device->iommufd)
-		iommufd_dma_unmap(device, region);
+		unmapped =3D iommufd_dma_unmap(device, region);
 	else
-		vfio_iommu_dma_unmap(device, region);
+		unmapped =3D vfio_iommu_dma_unmap(device, region);
=20
 	list_del(&region->link);
+
+	return unmapped;
+}
+
+u64 vfio_pci_dma_unmap_all(struct vfio_pci_device *device)
+{
+	u64 unmapped;
+	struct vfio_dma_region *curr, *next;
+
+	if (device->iommufd)
+		unmapped =3D iommufd_dma_unmap_all(device);
+	else
+		unmapped =3D vfio_iommu_dma_unmap_all(device);
+
+	list_for_each_entry_safe(curr, next, &device->dma_regions, link) {
+		list_del(&curr->link);
+	}
+
+	return unmapped;
 }
=20
 static void vfio_pci_region_get(struct vfio_pci_device *device, int inde=
x,
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools=
/testing/selftests/vfio/vfio_dma_mapping_test.c
index ab19c54a774d..e908c1fe7103 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -122,6 +122,8 @@ FIXTURE_TEARDOWN(vfio_dma_mapping_test)
 	vfio_pci_device_cleanup(self->device);
 }
=20
+#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
+
 TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 {
 	const u64 size =3D variant->size ?: getpagesize();
@@ -192,6 +194,61 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
 	ASSERT_TRUE(!munmap(region.vaddr, size));
 }
=20
+FIXTURE(vfio_dma_map_limit_test) {
+	struct vfio_pci_device *device;
+};
+
+FIXTURE_VARIANT(vfio_dma_map_limit_test) {
+	const char *iommu_mode;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode)                     =
       \
+FIXTURE_VARIANT_ADD(vfio_dma_map_limit_test, _iommu_mode) {             =
       \
+	.iommu_mode =3D #_iommu_mode,					       \
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
+
+FIXTURE_SETUP(vfio_dma_map_limit_test)
+{
+	self->device =3D vfio_pci_device_init(device_bdf, variant->iommu_mode);
+}
+
+FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
+{
+	vfio_pci_device_cleanup(self->device);
+}
+
+#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
+
+TEST_F(vfio_dma_map_limit_test, end_of_address_space)
+{
+	struct vfio_dma_region region =3D {};
+	u64 size =3D getpagesize();
+	u64 unmapped;
+
+	region.vaddr =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
+	                    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	ASSERT_NE(region.vaddr, MAP_FAILED);
+
+	region.iova =3D ~(iova_t)0 & ~(size - 1);
+	region.size =3D size;
+
+	vfio_pci_dma_map(self->device, &region);
+	printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", region.vaddr, size=
, region.iova);
+	ASSERT_EQ(region.iova, to_iova(self->device, region.vaddr));
+
+	unmapped =3D vfio_pci_dma_unmap(self->device, &region);
+	ASSERT_EQ(unmapped, size);
+
+	vfio_pci_dma_map(self->device, &region);
+	printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", region.vaddr, size=
, region.iova);
+	ASSERT_EQ(region.iova, to_iova(self->device, region.vaddr));
+
+	unmapped =3D vfio_pci_dma_unmap_all(self->device);
+	ASSERT_EQ(unmapped, size);
+}
+
 int main(int argc, char *argv[])
 {
 	device_bdf =3D vfio_selftests_get_bdf(&argc, argv);

