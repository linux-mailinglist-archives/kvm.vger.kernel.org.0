Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3363975C2B8
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 11:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjGUJPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 05:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjGUJPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 05:15:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDF91984;
        Fri, 21 Jul 2023 02:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689930918; x=1721466918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mfTa/y8jW/suBimxNYIA3MBGl1EQrn911EZDITR3UX8=;
  b=hYRW/yGQdWIqlLySZKMlA99L4NdARaa9jBUF5WjqWxkpHziVuL9FuWDA
   8ApUS1yj8OxVaBdgS4z+rKQw9HMlX9EMYFsyWBmC9+gkAtvvFRTR48T0u
   79OPAiJUjXBEEKWwmk31S492S8pFb8J6tCDY8S3lda3MeEVjyYNC+Htg2
   cbegyUcX0pPfqEXK7T2yraDXw6w7FG//locWVjcdBG8OpoYQqmFaNPLfY
   e+nWVWJWFCpRrMRy5gmYAmp5/tbwVjUTrPu98B3z3cqIjya9EpBv587IL
   47BpgSdQabcytRJhFvmhsvGKMlMFMtcutDT2Ht/kVSeDZvkz3ZotIVaGI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="397868649"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="397868649"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 02:15:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="701971349"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="701971349"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2023 02:15:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 02:15:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 02:15:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 21 Jul 2023 02:15:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 21 Jul 2023 02:15:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDpTiYpsSQtbPbOqjTPxO1+nZ527Sp4YPdEHevzUKXwkLqCoD26uBdRJzIZZ/nkRdT26ZUc8ZtAkJo7+1KWkFVU8SHmVp87AmO86gKi4Sga3eNKBmmLmnl4FD4S/E2pHgQzXzYSBKnJ2vUqsngFiNhxx777lJhUZB0gBIoEJa0VnZcs2mseCcrS6gKIBnsK3sufDmJIWs2eIoUSiwOjpGAd4labNKYkp6tFp1OEObw4jYjirf5prKK4piuvf0RbHtOVGLoBPMqvrahZPhIe2jKlLdl3TUx663nm0JkybigZ78a7iAYFAZkVXO6C2CS/IgsdUgoTM8NpK2mdCFD+Bmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsaNIBLY35ougmoUp6heBh86iwlO1ffuE9KCbzZZg4o=;
 b=d9WhLfaZdtPuNpkIKW3cc08CYBnQNL8B3SwT3IAeEupQ8E3b4GQfweKVFS2puP7b4s6gtXvjsh/vFQepgx3+yAwcJRJgPzSw7Y6rwGDXGXMJDN6B2Ck0RzdtAN/E+29tjr2TyO7tu8MCRc48lzsMYesQRvZNmJjtfClGM6arfIyLfDE/G9jZvNXEUAMy1FQcEIvgGe/k+tibnoY8IBx5nlTERw5/EKPlYnuEcX7NA4z+NyXcWTJTVRNHc1wjVpFQ6U8cRFtXzvpnSt/RkYvXFjqokmWIG0WuJO2eeDWgH6C1OLBVS1iCkIVxhNyDGqbKV2TXP0iz6HhKzoS0FWJV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Fri, 21 Jul
 2023 09:15:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 09:15:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v12 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZupFmkHLXvoHLwkSg/oL5LnrRZ6/D7upA
Date:   Fri, 21 Jul 2023 09:15:13 +0000
Message-ID: <BN9PR11MB52761AA921E8A3A831DD4A1A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-5-brett.creeley@amd.com>
In-Reply-To: <20230719223527.12795-5-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5627:EE_
x-ms-office365-filtering-correlation-id: ddde682c-a685-426e-7f8c-08db89cafd63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YxzL5gaGbA3KsokiDujjae5AYLo2AtUB5d2D5IxXZh4lJ+/s1p6WCbFWB0FBKvR1TnSRFI7gnZOjG9qHxxYl9am5hVW0KwtWc5WIH3BmNuJWj4zwGF/XxEZHVc0TPA6pqKnx4r8GxMmrBCP4pqy/NsKa8MPCks1uat9eebGSqsNZg+z/O1G5VhFTNbE3mHkT4Zm+B4bkKTunGpQoAmIYmOcs49pWUexF0sWR0kBIN7RFFdLJ5uOnNeMlH22X9ro3qUPbobJpYwu1vFafkqwDX8iXbaGVe7hAEtmtZJbIMGL3XEwXmRs8UFC0iK3TCToV6vZwq+F/CzFYM0BT9E2QBtoYmpL3oMuTpPVs8GmUlcUZ5a6MeEiyNycpXUg+nPXMn1RTDJx6Z7AlAxd0KnL32ugUE6S8gqsbeal/AidDBsTRG1irfuRF9EnTqSWROH/WsSVQBOUDrP+cjN8732SW+dnITBh6+zUiWoxGUjjOdQKrq+j74HAW0bkpgvlraX7u8k2X2naUAW+tXcByHhlrjDn3aP/mjD8Lfk8yCP11uI+a3sYY70Wy2G/bnkCtn2VT8TlvI+wvEjMeFrN5O83CrT4JfRjgC88MAqt+d/UM9WS0t5dZiVeekuNi/q8X5f8K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199021)(110136005)(122000001)(71200400001)(55016003)(82960400001)(7696005)(478600001)(52536014)(5660300002)(8676002)(38070700005)(33656002)(8936002)(2906002)(86362001)(66556008)(4326008)(38100700002)(76116006)(64756008)(66946007)(66446008)(66476007)(41300700001)(316002)(6506007)(26005)(186003)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T1ZKIk/nhWbbrNQiF11EjapXAFgXxxFs4GE/2+nXtVHPkNyAN1IVoNcUtlbD?=
 =?us-ascii?Q?52bH9zLGUlphto7hCDj3ENYKoySvGP+5q5yYB55Xm9wYs8IJJUnz0uUb8YhW?=
 =?us-ascii?Q?lKOviV90KR19oqiEqvHfB87UBaAc89Nezr8WgnmbuS3HhhI4kPr8NPGD1ut2?=
 =?us-ascii?Q?yZM5jpnIWzMnxe/W5wR1HM+OdNEcVMz0TepQvB/f1no0E2pTOaSpJxLSpakM?=
 =?us-ascii?Q?ugvNSu2WDv9CgmLF1V39Kxo4wKJuO60RDdk38+OxXmGah2WOPIN80J/OVeeE?=
 =?us-ascii?Q?HKYctLS70UVr+gBu79RTrWtJWHal4QzR7VclCsPFliVi//mULyD4G9aKThqQ?=
 =?us-ascii?Q?IXA83Sc7CLzhl2Zduk6GzIrcJwCn0Wi3LPQBpCmI6ea2GBL3luWI+8J/0U8W?=
 =?us-ascii?Q?0/i5h0P886WnBceOcDOpJOqsBtj6YuxqAhUZmXsUOtTlGTW+2cv2EUpCpuwI?=
 =?us-ascii?Q?ErvfZ8xjbwKne/qa0s0xnHQ8dUyh3b35poTSAaAS+3rt/RL0Lfv7jdtfdGXH?=
 =?us-ascii?Q?vcUNpm306rpnsb/K+UmAmJU91AOM8OrjSuRQyyud/n2VFVfjVyir2gFO4DPn?=
 =?us-ascii?Q?e5TulegxqNadlsaZSkm4nzt8vIInreHB46jvx+EZeFLFnzCOFW5CdQM7AZcz?=
 =?us-ascii?Q?iNJH5g90xNWleJIJG8N3wzwGGAOtQg+f8bHl5qF5rZ3OPoOMm0UpufskZlLu?=
 =?us-ascii?Q?/XlmlNgWR55w8v6huFDm4RD/rRCMYgaEo55UcL3M1p/gfMF8iPUX6nMwdD1U?=
 =?us-ascii?Q?TqsHpREaFGYbAY1E987DbxW6lRi9caUlP6WGDxxGNzorCAdPWh4lFauXHXLc?=
 =?us-ascii?Q?JjWYrrgBAv8pXttDp9Oe8lBvPeTyFktXo3MsH/JtRucwTuOYqXAs7sEbRyuz?=
 =?us-ascii?Q?l5zyR3gzQFTBNaYWiPQg6ulDh2xngPf+p2gyPZGLrvVqrcPKZz79AVn2Svdq?=
 =?us-ascii?Q?DzDo13bKfXqrU6tV71Ho/fD0c8zekeipZe5DIA/NKpneq2duY8qMnB0oc7Fm?=
 =?us-ascii?Q?TrtNvOS9Fz4VRlpOCgpz0KaCTsXPEcAvhVwhDTtVs/vkpv4atLDJqhWGh3iH?=
 =?us-ascii?Q?RHlZG/wr2u1oOf1sYggaa6tFYVo8Xcsos31xyiQYYVNmUWiLBGBQ60iBhaZf?=
 =?us-ascii?Q?GNOg1SjkPtaShVGAa1GF0d5FSnWO3rW7kfrWX4qz6lx5mFLXM25LgmKFMqr+?=
 =?us-ascii?Q?ZC0lMmILddg394/upssbHPVyI5yvcFZBKNjQmGvfBCOA2UbIUwBy9pEl5tQg?=
 =?us-ascii?Q?8J0cA9Np2Aw9SzycpgKjPuCtgOX8Y2bxB50REZyCxr3/qsVthVKmp7lGmiA6?=
 =?us-ascii?Q?Hq6SmiBT7QS8KNqgxiGN4JNRIbSMxyJ9hQg5tH7iMoayPT3NgokJjDDVjLBc?=
 =?us-ascii?Q?neqjRiZEZgb6WN6foSM3ThCOqTZSy4xW/9yMnHKL4lnbFzXoDs/izmNMKIOZ?=
 =?us-ascii?Q?FlkBm5aPpVNNLNRcVGAhajVyxmpg2CG9321MFdUpISfRm1uCUCDJPE4wIvYF?=
 =?us-ascii?Q?v+ST9evW62rf00FG13JdyXl86ut+h5eX92XvmVJs/51m+lbgHdalXbjpY0hO?=
 =?us-ascii?Q?PHHGaHL7x+bTU+oS+02Gx/wq03NqcR96Gzbts6fq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddde682c-a685-426e-7f8c-08db89cafd63
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 09:15:13.0480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RrIxwUn/7lyxkaO+Qk05bOS8BQNeivDGxbvIY3GYrA8C6TY4gAPyfU9BZsjOYvCOScFQF/S85kJeD9i5qhj0Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Thursday, July 20, 2023 6:35 AM
>=20
> PDS_LM_CMD_STATUS is added to determine the exact size of the VF
> device state data.

based on the description PDS_LM_CMD_STATE_SIZE is clearer.

> --- a/drivers/vfio/pci/pds/Makefile
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_PDS_VFIO_PCI) +=3D pds-vfio-pci.o
>=20
>  pds-vfio-pci-y :=3D \
>  	cmds.o		\
> +	lm.o		\

nit. "migration.o" is more readable.

> +static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vf=
io,
> +				      union pds_core_adminq_cmd *req,
> +				      union pds_core_adminq_comp *resp,
> +				      bool fast_poll)
> +{
> +	union pds_core_adminq_cmd cmd =3D {};
> +	int err;
> +
> +	/* Wrap the client request */
> +	cmd.client_request.opcode =3D PDS_AQ_CMD_CLIENT_CMD;
> +	cmd.client_request.client_id =3D cpu_to_le16(pds_vfio->client_id);
> +	memcpy(cmd.client_request.client_cmd, req,
> +	       sizeof(cmd.client_request.client_cmd));
> +
> +	err =3D pdsc_adminq_post(pds_vfio->pdsc, &cmd, resp, fast_poll);
> +	if (err && err !=3D -EAGAIN)
> +		dev_info(pds_vfio_to_dev(pds_vfio),
> +			 "client admin cmd failed: %pe\n", ERR_PTR(err));

dev_err()

> +void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device
> *pds_vfio,
> +					 enum pds_lm_host_vf_status
> vf_status)
> +{
> +	union pds_core_adminq_cmd cmd =3D {
> +		.lm_host_vf_status =3D {
> +			.opcode =3D PDS_LM_CMD_HOST_VF_STATUS,
> +			.vf_id =3D cpu_to_le16(pds_vfio->vf_id),
> +			.status =3D vf_status,
> +		},
> +	};
> +	struct device *dev =3D pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp =3D {};
> +	int err;
> +
> +	dev_dbg(dev, "vf%u: Set host VF LM status: %u", pds_vfio->vf_id,
> +		vf_status);
> +	if (vf_status !=3D PDS_LM_STA_IN_PROGRESS &&
> +	    vf_status !=3D PDS_LM_STA_NONE) {
> +		dev_warn(dev, "Invalid host VF migration status, %d\n",
> +			 vf_status);
> +		return;
> +	}

WARN_ON() as it's a driver bug if passing in unsupported status code.

> +
> +static struct pds_vfio_lm_file *
> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 =
size)
> +{
> +	struct pds_vfio_lm_file *lm_file =3D NULL;
> +	unsigned long long npages;
> +	struct page **pages;
> +	void *page_mem;
> +	const void *p;
> +
> +	if (!size)
> +		return NULL;
> +
> +	/* Alloc file structure */
> +	lm_file =3D kzalloc(sizeof(*lm_file), GFP_KERNEL);
> +	if (!lm_file)
> +		return NULL;
> +
> +	/* Create file */
> +	lm_file->filep =3D
> +		anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
> +	if (!lm_file->filep)
> +		goto out_free_file;
> +
> +	stream_open(lm_file->filep->f_inode, lm_file->filep);
> +	mutex_init(&lm_file->lock);
> +
> +	/* prevent file from being released before we are done with it */
> +	get_file(lm_file->filep);
> +
> +	/* Allocate memory for file pages */
> +	npages =3D DIV_ROUND_UP_ULL(size, PAGE_SIZE);
> +	pages =3D kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
> +	if (!pages)
> +		goto out_put_file;
> +
> +	page_mem =3D kvzalloc(ALIGN(size, PAGE_SIZE), GFP_KERNEL);
> +	if (!page_mem)
> +		goto out_free_pages_array;
> +
> +	p =3D page_mem - offset_in_page(page_mem);
> +	for (unsigned long long i =3D 0; i < npages; i++) {
> +		if (is_vmalloc_addr(p))
> +			pages[i] =3D vmalloc_to_page(p);
> +		else
> +			pages[i] =3D kmap_to_page((void *)p);
> +		if (!pages[i])
> +			goto out_free_page_mem;
> +
> +		p +=3D PAGE_SIZE;
> +	}
> +
> +	/* Create scatterlist of file pages to use for DMA mapping later */
> +	if (sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages, 0,
> +				      size, GFP_KERNEL))
> +		goto out_free_page_mem;
> +
> +	lm_file->size =3D size;
> +	lm_file->pages =3D pages;
> +	lm_file->npages =3D npages;
> +	lm_file->page_mem =3D page_mem;
> +	lm_file->alloc_size =3D npages * PAGE_SIZE;
> +
> +	return lm_file;
> +
> +out_free_page_mem:
> +	kvfree(page_mem);
> +out_free_pages_array:
> +	kfree(pages);
> +out_put_file:
> +	fput(lm_file->filep);
> +	mutex_destroy(&lm_file->lock);
> +out_free_file:
> +	kfree(lm_file);
> +
> +	return NULL;
> +}

I wonder whether the logic about migration file can be generalized.
It's not very maintainable to have every migration driver implementing
their own code for similar functions.

Did I overlook any device specific setup required here?
