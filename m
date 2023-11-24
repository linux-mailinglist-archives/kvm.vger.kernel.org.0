Return-Path: <kvm+bounces-2423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2FF7F6EC1
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37CC5B20FA3
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E158BFA;
	Fri, 24 Nov 2023 08:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C50591;
	Fri, 24 Nov 2023 00:47:04 -0800 (PST)
Received: from kwepemm600005.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Sc7lC6dxRzMnNL;
	Fri, 24 Nov 2023 16:42:15 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 24 Nov 2023 16:47:00 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Fri, 24 Nov 2023 08:46:58 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, liulongfang
	<liulongfang@huawei.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to
 mutex_lock
Thread-Topic: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to
 mutex_lock
Thread-Index: AQHaHXtQ33FJcdWa9EiPkr1jMA8jDLCJKO2Q
Date: Fri, 24 Nov 2023 08:46:58 +0000
Message-ID: <eb2172d1e24044059e65d15b10391f65@huawei.com>
References: <20231122193634.27250-1-brett.creeley@amd.com>
 <20231122193634.27250-2-brett.creeley@amd.com>
In-Reply-To: <20231122193634.27250-2-brett.creeley@amd.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 22 November 2023 19:37
> To: jgg@ziepe.ca; yishaih@nvidia.com; liulongfang
> <liulongfang@huawei.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
> alex.williamson@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Cc: shannon.nelson@amd.com; brett.creeley@amd.com
> Subject: [PATCH vfio 1/2] hisi_acc_vfio_pci: Change reset_lock to mutex_l=
ock
>=20
> Based on comments from other vfio vendors and the
> maintainer the vfio/pds driver changed the reset_lock
> to a mutex_lock. As part of that change it was requested
> that the other vendor drivers be changed as well. So,
> make the change.
>=20
> The comment that requested the change for reference:
> https://lore.kernel.org/kvm/BN9PR11MB52769E037CB356AB15A0D9B88CA
> 0A@BN9PR11MB5276.namprd11.prod.outlook.com/
>=20
> Also, make checkpatch happy by moving the lock comment.
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 13 +++++++------
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h |  3 +--
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index b2f9778c8366..2c049b8de4b4 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -638,17 +638,17 @@ static void
>  hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
>  {
>  again:
> -	spin_lock(&hisi_acc_vdev->reset_lock);
> +	mutex_lock(&hisi_acc_vdev->reset_mutex);
>  	if (hisi_acc_vdev->deferred_reset) {
>  		hisi_acc_vdev->deferred_reset =3D false;
> -		spin_unlock(&hisi_acc_vdev->reset_lock);
> +		mutex_unlock(&hisi_acc_vdev->reset_mutex);

Don't think we have that sleeping while atomic case for this here.
Same for mlx5 as well. But if the idea is to have a common locking
across vendor drivers, it is fine.

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

>  		hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
>  		hisi_acc_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
>  		hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  		goto again;
>  	}
>  	mutex_unlock(&hisi_acc_vdev->state_mutex);
> -	spin_unlock(&hisi_acc_vdev->reset_lock);
> +	mutex_unlock(&hisi_acc_vdev->reset_mutex);
>  }
>=20
>  static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> @@ -1108,13 +1108,13 @@ static void
> hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>  	 * In case the state_mutex was taken already we defer the cleanup work
>  	 * to the unlock flow of the other running context.
>  	 */
> -	spin_lock(&hisi_acc_vdev->reset_lock);
> +	mutex_lock(&hisi_acc_vdev->reset_mutex);
>  	hisi_acc_vdev->deferred_reset =3D true;
>  	if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
> -		spin_unlock(&hisi_acc_vdev->reset_lock);
> +		mutex_unlock(&hisi_acc_vdev->reset_mutex);
>  		return;
>  	}
> -	spin_unlock(&hisi_acc_vdev->reset_lock);
> +	mutex_unlock(&hisi_acc_vdev->reset_mutex);
>  	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
>  }
>=20
> @@ -1350,6 +1350,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
> +	mutex_init(&hisi_acc_vdev->reset_mutex);
>=20
>  	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_PRE_COPY;
>  	core_vdev->mig_ops =3D &hisi_acc_vfio_pci_migrn_state_ops;
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index dcabfeec6ca1..ed5ab332d0f3 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -109,8 +109,7 @@ struct hisi_acc_vf_core_device {
>  	struct hisi_qm vf_qm;
>  	u32 vf_qm_state;
>  	int vf_id;
> -	/* For reset handler */
> -	spinlock_t reset_lock;
> +	struct mutex reset_mutex; /* For reset handler */
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
>  };
> --
> 2.17.1


