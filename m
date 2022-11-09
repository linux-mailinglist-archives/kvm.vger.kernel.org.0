Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E46B6222A6
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiKIDgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKIDgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:36:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF67712D19
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667964974; x=1699500974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wUWBydlcIfm7yJJBAGDthGLcmJqkiel8tVKYXXSx61o=;
  b=CZXkUqTB6Fslyak4Ckuh9CBByHu9KiD7O8o5DITBRSo/TgUIRIJpI0GP
   UWLI6lXx/p9yp7re3xK2wNjFR+0r1inws5W6VHShUL7exmcJrXNLifDO3
   iqRcknATpeUxVzQFdO++KEcloS4zSkb4yvJmJVPt9KkW6Mv+NaqHM08CF
   jgy2odXrzUAQTx23tmsqbkNPs2AMMo7kK0X7kG3lPVqOZzP3C+zWo/86L
   cwAL3SOAnaxtFrpvA0MdWWltujkkWqXWahqNFtSkufGPvpOZ7WfPgPyyY
   0RjdaDF0F9o/sm7r9vkqFchz1IQevWjgkr5hOi2Se7awaG8cTAOSN5xso
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="373022336"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="373022336"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 19:36:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="742222298"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="742222298"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 08 Nov 2022 19:36:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:36:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:36:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 19:36:12 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 19:36:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVAkaQ2Ra1DxSi3yisPFOpqt6VWSo1XOKYe/jMODrfLzLQ1MYyG/44f3m0k3bg/Tb1zELv/BC3PNKtPh931kn87NmOUwsD6b2uKAn+dPZXXQTkUl01KplXePJZKTJXEr5f3EdPerVY9IW9AbUiH5UAaBo2UMNpR4YAHXOs8SoVRXoOLA3vr+yNBaYPTXsMZ/Hl+ao+z++7RZ/9HZWPLbX/zpqE8il2O6iuGz1rU29asc/dsmmOqDk0QXXlPyJIeQQZlPA5Q7EhTMgYbrnjryqhFbhvJ2W3k/6lOcKusRKgCh0qK1HuEOimKpjnRitor4w5IQKyL4BjTWwo8JTkj3Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUWBydlcIfm7yJJBAGDthGLcmJqkiel8tVKYXXSx61o=;
 b=PIj57jn8deH/bJA12tS0KUfE/s4ndnSzLj8LvPzrXhIbHN6m5zDt6o9SrEbm1WKob2ySbCGRoeaCFEHe3NpE14P/eACQvLZzpwoFbNoTt3UoiJlUj262ygCs3IMX2CNGQZHt9RLSRmZBCymAPSRQeDsO6SE7nXlzDRXjhgPGZaxW4M98LssIAUr8p/Wdz5nrotbS4Qd7ZR6Hcp7G21mLr7LOhZP3JKhVkdPKPufbxEb/pEasHCGYcpQLF00SgSBxbfujM4ttKO4nzba4Eio5/N3BRKq81mXVxsOWl0tMv0iR3yCE/aHB9CSHdJwXGIJ8f1hykL5Wj0BImmSHRg8ceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6487.namprd11.prod.outlook.com (2603:10b6:930:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Wed, 9 Nov
 2022 03:36:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:36:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH v5 1/3] vfio: Fix container device registration life cycle
Thread-Topic: [PATCH v5 1/3] vfio: Fix container device registration life
 cycle
Thread-Index: AQHY8WkNnS57W5/XrkGirEHph0gz2q419ccA
Date:   Wed, 9 Nov 2022 03:36:10 +0000
Message-ID: <BN9PR11MB5276CB35FD0334BE58902B998C3E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
 <20221105224458.8180-2-ajderossi@gmail.com>
In-Reply-To: <20221105224458.8180-2-ajderossi@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6487:EE_
x-ms-office365-filtering-correlation-id: da725864-9d7e-4df6-d43b-08dac2038b35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kMGaDCq8s2jztJx4zQ/EgcSKB1wmSGuo/PkcKV+5lG+pip+RMBW7ElHkCB1L44ZF2NorXLT0B2kXKnfq8GCkt2NqRutaMp2gt54t3/K0bSXd6YVTPUZf6JXCa7nqDJQnYlXdQVDiRqfHtUpUL9zqOq09t2CJIqtYZSplmXof1RndwUVRqqdUHdN2hu5zR/Y/JYMqTpux+SaQeftHWS85V0WQrwYP+4RbBnIJokr9La+xAZRkeiarwg4dSVAGF+v2NHIh20EkceMtGLCLWTxUeeBqW5et8jeQ2KvlLrJYJ5gpexv0a85adaepLhA0Z0tDGCPpU+dNSPQbr269GaHh769J7vJMEi99ilDmOyX44oJwwI55avjsD9l4k2CeaXGvIlZMLDg2JhupeWyX9R6laWZp4CDIQcsejjsCJAGBpZP4Wr3r6F9mVIyTU6yFcyu/t1kHkflRs6R0tjJaVbMdR0iGbficFd9lVf6VXqSeF4CQBMISfHQzSUuPcIST39N1ptYzQlYGod/6LmYl7Y5mVqsGsKE8sz3k+Jvc+IeROUugU8VTnY+X8KlRpxHYkphtkf+te6dg70TdpRztcVXzjAGksv38T1SSuypauvfvZFv4yutpxqYet/h3o6z8mFb8xQpKtrNO8JUIjqFgWbSJFSCxd5MmZXtIo0WW9X1p3ACn5dKoo7dFFD6wYhxQGR6OUxMo9IFMRPzheNDz9uzpUTw3PF60U4nji+LSOUlivuPi2VccEUxXpgA1/JwvThq2FxrgHjZY7EeQQzOrb7D46Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(2906002)(33656002)(110136005)(316002)(76116006)(83380400001)(6506007)(38070700005)(71200400001)(4326008)(41300700001)(478600001)(4744005)(55016003)(64756008)(5660300002)(52536014)(8936002)(66946007)(38100700002)(8676002)(66476007)(66446008)(66556008)(26005)(7696005)(186003)(9686003)(122000001)(54906003)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kxZilzFECEaddqzY7KmQWs2KaQtsA6sXTyONdVqr2WDGipnVod8/2RhGWTf2?=
 =?us-ascii?Q?w1rRBJroGu4WN1bJa4gCB+T6eelkB0spjNLdEwu+qVdhg4FSgDBqy+tAtCh6?=
 =?us-ascii?Q?Ga7InD8n0gYtbikCx2Twh5nA1nezT9UIbtWxadJ2PNRmypTpeZL8wTCwfkeg?=
 =?us-ascii?Q?TLT4eapKxrp2qmDsniVrIIx9E+X2QlUNwRaZ5drhMSOjKZEPamYxDeeEQ8x9?=
 =?us-ascii?Q?CspcEQHcgZEKtIzScr9orf8e4tnOahB0gJ6IlKQ06/ClyKYTdeP3fpZVxuIp?=
 =?us-ascii?Q?r7gbevZxJUMQailgP4ojwxTcuXRKMXFeq1I/Uaikdw6nqRNF0XdOlUC6OkfD?=
 =?us-ascii?Q?RJaErzNZwqcN/Oau6GpQCpJ8HRm+Rw/8a8IU5ZGXRGV45+yNYW7o9bCREVdC?=
 =?us-ascii?Q?3DKVDI1oHT33ZNC8x6oTMe3B5It2uNWmbY38u1sOJRlRIXjDlq5Xi2qkPjr7?=
 =?us-ascii?Q?BwStFJ8ncTwHQEdS+pVU9RasUveux/gAK+5zb0xb15+XyNv9SYyiAPG7A3CQ?=
 =?us-ascii?Q?owN7rmCudWQnLlLtUWCcj4Lna7bHaYaGvby0s4FVDzVtfbdk2t0jhLxKYQYg?=
 =?us-ascii?Q?3jzZJZsznrcV6NhXkfbTGUi6/MkmR1Q6lVEgW5R6MZiABvzztnaj6Jf4hc3+?=
 =?us-ascii?Q?o+E2pOaJvTR5YrLkqCxKZ1QDrM+KOoUbjEYlIxnBow/31/0AEl2dZphdjY4e?=
 =?us-ascii?Q?SMtF52kS9diCewJZsTPIAnVK3kzLeZrZpJ9HPjW72ZRME0LKi0bUzVjLxiYo?=
 =?us-ascii?Q?/oJaKrZwgpvluZD9LUtuGBJOU08yC4q2toFFhFDm/slUWKMggWswBeebtSjX?=
 =?us-ascii?Q?7UCDB+VAnie7DdMsNF7pdXbcNB/PqVBeDvpgCn4+cQPbS4K8DM69q069bnqa?=
 =?us-ascii?Q?XUCBg+Law78brGz+AWFNp+gu1tU7DO5wZhb86ufYA6fAuWeEgy/1uug7JmOg?=
 =?us-ascii?Q?l7XQyLfPMMv7UrlFHbttisdBFgGMKM/m8lwZjd2dHr37WUw5cqzrSmat0Nr+?=
 =?us-ascii?Q?86QDHowx1w/VFwIMLMQdtlxxfRrjtvbiwNSgH3W7W7cmhd8Qqz7cxFrsIqRl?=
 =?us-ascii?Q?Whb/n4W6y4tdvWIcN8B7LJrVEuJIQpVlJMdChilyrHux1uOhEJfyVKLczjt2?=
 =?us-ascii?Q?e2VOhan3yoWaobm6L/3etpTTGkLjbQMh5T0JAyOA6PvERd3su0hnSzXWXZXw?=
 =?us-ascii?Q?dkR8FiPjfh1scj8ajCYuvHHrYzIi4s86I254VeYJsJqGpJlqjo2gWcW1Nfqm?=
 =?us-ascii?Q?9/SrPxWWaaPRIuNpcHTHXK+Sd+udEHqYia1bx8Z+f1ID24WopFvqPxTS/piv?=
 =?us-ascii?Q?oaFBZLot46SgMNOzS0fSf8gJSHYqHa5DU3wwdwyY5Dp1tTOu1CuU2SaOodO7?=
 =?us-ascii?Q?aqkOFNFa/u9k1o6ZSPaYqmtOaCbcKCcAyJybKmMFmoQ+IL1fxdNCmN7RIVHt?=
 =?us-ascii?Q?ypDIhUGZmNYsmU4zm16KRnrdrHLkK6l0C3+eC2dV0WPYuEe25mCgH6SpR98y?=
 =?us-ascii?Q?+7kV5sxkCqotQeNXtWJ46uMvWD6bbbZWC2oFfqTk0tU9pBt0HYrpZWom5YHU?=
 =?us-ascii?Q?2mZC5a85eRDg1G/4tfvYQYLwEk1wWHepRrdOHY/I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da725864-9d7e-4df6-d43b-08dac2038b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 03:36:10.2441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9WSwbeVXf2Bw1GiC2rkI8i0Dolq32iWcBALZkmaWdGGpMxkbWMRo7fxQ2wrxQ98+5Oi3qTFGLqblRT8qLHClIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6487
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Anthony DeRossi <ajderossi@gmail.com>
> Sent: Sunday, November 6, 2022 6:45 AM
>=20
> In vfio_device_open(), vfio_container_device_register() is always called

vfio_device_container_register()

> when open_count =3D=3D 1. On error, vfio_device_container_unregister() is
> only called when open_count =3D=3D 1 and close_device is set. This leaks =
a
> registration for devices without a close_device implementation.
>=20
> In vfio_device_fops_release(), vfio_device_container_unregister() is
> called unconditionally. This can cause a device to be unregistered
> multiple times.
>=20
> Treating container device registration/unregistration uniformly (always
> when open_count =3D=3D 1) fixes both issues.
>=20
> Fixes: ce4b4657ff18 ("vfio: Replace the DMA unmapping notifier with a
> callback")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
