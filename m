Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B3B741888
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 21:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjF1TCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 15:02:15 -0400
Received: from mail-bn8nam04on2041.outbound.protection.outlook.com ([40.107.100.41]:33888
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232047AbjF1TA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 15:00:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcQadPsZSAqngMwFiyCLxXxyEyk05hubirXv6Xipe8aMtY6ihGYZJL6335oZe1AJLhKmRqGqnqje2cl3U8TpPQzS62uid7NtdAl1+u1yMGijeKpWVSRFc/5WsyYgIUZ/puAdVbxGoJeEeEbo6rLcRsYoa9ZsIERGKtpW/LQiCJ7TixUryKrramzh8nl7w2zz0pZjm93hgl6C4TwjEfULwmFTXHBs+8QAXUQ8z8QW3XNFFMJu7OLBo0QesbccFYJJ5Tt1eEjlsuD0i441rJadJYAIs3llWmKJvrUk7I+XAq6VZeodOpYsbQcOAAskmrRgIJKDKzCwao1WzF+Qd9bpdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0ir1+o0kwXtzUcw+7I8spbQPfPJtLl4Kwb1J1Buf24=;
 b=oYUtnphp05HJpx/CEShTUBOQbqORBe8xteqD3nc45oB4tYhgFJYTPPus8ny6eG5oxiw4ljVjq8ViV2mQT0FadCtLmkVPFLzt2fLGJaLQXyRDhZfaDMHXfQ+mq1b0qV5hliwNfr+9DpWnqsltARS8goOetUk4wLJNhPgzf5xauemQj/LrGGLicOOIwYUW5J3qSQmZFrLUFxQINdRc9FjHqfYsVsLSeu5eP8VV7lX8m1/tCvKK9T9OGfqZkjwgdb8A1eySXSy7vi1q8WkOJFfZt7WkMyDuACED4iSopa+3NE7wGZK/DjtY+u+Ax2trAquuwEjjzN6GHhxIChAL1Wm0fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0ir1+o0kwXtzUcw+7I8spbQPfPJtLl4Kwb1J1Buf24=;
 b=THsYLFs0+igtY+aPXVjJywdH2ErFBNtCU5aYjCO4CeXp31BkLPfn1cZSlyhcdAI13Cst/TkLP0Ur3/KckftuRIGlPQT0qHAL9hVL7nqJxlxFlhacNMhMF3mfA0QE8kfrLfNYRQ3tVEeQMxcqefugxBSAyl1Oxli4xHWUiNJ4OjkfttkoE+qshc2JgNOBIBZIhvv4JUgLeO4ezeBvsNo8ikCoAJSC82ZmkYwmVlGcU3btVYghxit+RhVHCr6zZTaBdvkLZBbAGcCIUG9nSPFgqEPgjOiWQKdOO6knwMUVCLVsE91yRyJCgk6DumSHBWNp7KmYe7YUfvzJtZNjkh0O3A==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by SN7PR12MB7809.namprd12.prod.outlook.com (2603:10b6:806:34e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 19:00:54 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8634:5f0e:cf09:a084]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::8634:5f0e:cf09:a084%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 19:00:54 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <ACurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZpLaxSTuRkhXihUusFX/7jkP6ra+YYxiAgATjz4CAAASmgIADTv3w
Date:   Wed, 28 Jun 2023 19:00:53 +0000
Message-ID: <BY5PR12MB3763EC8E078A5C43FEBEF050B024A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
 <ZJWdbbNESp1+6GVN@nvidia.com>
 <20230626100629.3c318922.alex.williamson@redhat.com>
 <ZJm7a1BpeLmQQ5Mj@nvidia.com>
In-Reply-To: <ZJm7a1BpeLmQQ5Mj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|SN7PR12MB7809:EE_
x-ms-office365-filtering-correlation-id: faef47ce-7250-42b3-57bb-08db7809ff88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 44moyq27dL3wZKYc3N2//5gdx/luEh7iGWS+nR1mlNDXp3doTIiB7iWKSWnXqQI3qa/Eka5hseTbFELIfbX663zzus59krXu1ENq47pMNOQv8ZquqlRcSdDyqK1R/Lq3RuxYGswU33SdjFcy1nJGfOGdIajEw0g9dN83MZnew/I4rLiF7vFiVMLrEX9fMBAV7ZbzmeovdvvubvMRVbuD2MBLk2bCfGP8rTdnnLW4ycXyZqGodUtxjcP6xzF3c9p+bPbk+UC+kciwil3RDriRv3d4N3WPnU1aGf8v8gZYqlDs/ovxFjy2CFKQ7RryYIdlUHNAZxb/3I5qFsKygpt77xd7tT94FfukO2Gq9feWydkLBa1WuQDfeGs0Hu5zgi9MOqo9Wslz7Gvc7BXgmfZRzr+69N6ylebcgYl/QqUiyF/5fs0R/2NRsk0Tq+uSn7Or2aZ06VOACplVJduj8fKnOuE0QEehXadwf61ToPiT4YxpAAoqkbbdxAh26d4CSCvSW2GnjVdq76Ng8uFuqguwQxdsuOsQdQGQpXKC3Y3rx1lJaPy02cw/t98Fkn7bYcCLfNDdgGOdecaS/k2Tu6rl1gRxOVBgMggxe8NhGwK2C94MLczWs9E77q9ecyQn0BmY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199021)(64756008)(26005)(33656002)(55016003)(66946007)(122000001)(86362001)(52536014)(5660300002)(41300700001)(4326008)(38070700005)(8676002)(316002)(66446008)(66556008)(8936002)(38100700002)(66476007)(186003)(6506007)(2906002)(76116006)(7696005)(9686003)(54906003)(478600001)(71200400001)(83380400001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QabwE7h9vsMEneh+s02vzquta4Sj8njtSMLfttHziGXGQCzUEqZg45cINaYe?=
 =?us-ascii?Q?fWHTMHMB1JHiwvhd5hCaLFaHyOTlpXMID2nSUWh+6ZowJyqmnJZqJ2lzJT04?=
 =?us-ascii?Q?z1ntuAlFLTUUo1ur7B05OBUsWJunJbe1JP9ToVs+bb2D0a93LO6NLAwFSpVm?=
 =?us-ascii?Q?/NxkjbjC8xLWSHezV9tjFebrtMm5Zp8TiFSLt4ut4ZBFT1fSs4rbinYSzrjl?=
 =?us-ascii?Q?jSdS9R9l88srtLLQ5oP0CI5BC6YLlrAbQD2UlMTC61xRiVpQFrrt7/RNhJ/4?=
 =?us-ascii?Q?L/4Thd3bu2UOsG8QCm13VcZPuz8BbDGIa846vXSHYPYa6AjN59ZFoe/GVgHN?=
 =?us-ascii?Q?OvTQasqLMtBpaOA3wgMlXMQvDrfOJ9fFWeYM6v49S6D7IYeNWEnROlfPVP3k?=
 =?us-ascii?Q?Of986s+yoYPCwpqLW4MphUNz2PPA/n0F/CjwwS+lAw1Epm2tWXJPy6wwMWjV?=
 =?us-ascii?Q?dTBZG/OsUpjX4UYU+DsELVL9WjtR4gC5FxUL4qE7QZnZ+VZjX1Phgd8qBmv2?=
 =?us-ascii?Q?rUSZWqRJKw6w2g/U/8D58aAVjx5ZdGPkLWHlJVpEyKN+OTC/qOON2sqGpRay?=
 =?us-ascii?Q?hnk9XFXFmooOYH6u+5BP+PCd90xW0Q3tdMEA16a+cQLcxjAbf/IYr3XrGwyJ?=
 =?us-ascii?Q?mBX0SYXZU6yERoxynOsaoAYVAhrlVR2fW1uVHdmICbk4IcOvTNvCbXpQ6lDz?=
 =?us-ascii?Q?k/VlmrMFH55Mt3YI95dxTklP8O6AxJn3r3C4KdG/bXIw3NYP7/N+Kmm7tGpl?=
 =?us-ascii?Q?GQiMiBA7ciMX3MDu0Xl0LVr1oKbP5F2GaQhjNB9R0eI800Huj4PQdaX6NJfb?=
 =?us-ascii?Q?f+9bHK5td+zJzAbkLQWh/1rDKHGhLdQlD23ceEYK1kef3hq541bRKeX/D1Ze?=
 =?us-ascii?Q?E+4m6ds2kL6fyqs2pxXaC6N6gju79gAeXQXlbY5O1q7m+UnNQpZ+m34yooGC?=
 =?us-ascii?Q?VTAStAXtngTPFB86fOGLpEVOGSFv8qm2Dpdp0ocBUYPoi9Ri5vXlkRw3O6Yi?=
 =?us-ascii?Q?mQYb0kkD2JU6zW1PNzcxfliWeXB7da8zeb9VoOUF19/8nh3tCsiq7oIO6QsQ?=
 =?us-ascii?Q?fx6kXCsh0sI2Mn8dQm8M04zjbEu/W+Hp49hCufFV6RWVFxSoAsGeSP+WUbl9?=
 =?us-ascii?Q?nymgfD1zcn/gIf2VammIGZLCDV/zLoUtBMR+9B+s4EzoLoSiBR+lLEku21Gg?=
 =?us-ascii?Q?MgwUB7TQE6OGxhoT9mPQUevFPZlR5hFimDil/b8IQseJp+rFO95wscWWz25T?=
 =?us-ascii?Q?48ujoCw/YmeLIa7coeRgyGXFj7Ps6x2oMD/NDDMDROpVpwRkjhafeJdAQRI1?=
 =?us-ascii?Q?V82yD7673ax0/AHQxXNC7eu+3vfPjamxx8GIaag9VXRkjFRZlgNneRmBxisF?=
 =?us-ascii?Q?Um2aOhV60SD6yJOak3+beqjxWqs2+YCRiSxrcd4ubBuse3Db7wJUw0S1gt1z?=
 =?us-ascii?Q?ZzHQJ9RjappxrAgx3TZoWBAaPe1p1Sd7t6qnS2lkkF+298SmRe56HMViZo+B?=
 =?us-ascii?Q?UU7ywP1Kj7su+bzNiSp2bRrDlI65UVVDecQTIcfrGiSgDv08B7ZCk6jmi9iq?=
 =?us-ascii?Q?84r35MQBuilDw6i9OKVuLWwY15Xy8ZlDzloDAAub?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faef47ce-7250-42b3-57bb-08db7809ff88
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 19:00:54.0205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0G7jq+XNtg042+bc+qfkc/Xp0eblSourAjZ39DxtLUcWg7rI54AFmTtKCyu5L9WVFKOpMEi7bWNNsOEOPHW5QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7809
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> +static ssize_t nvgpu_vfio_pci_read(struct vfio_device *core_vdev,
>>> +           char __user *buf, size_t count, loff_t *ppos) {
>>> +   unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>>> +
>>> +   /*
>>> +    * Only the device memory present on the hardware is mapped, which =
may
>>> +    * not be power-of-2 aligned. A read to the BAR2 region implies an
>>> +    * access outside the available device memory on the hardware.
>>> +    */
>>> +   if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX)
>>> +           return -EINVAL;
>>>
>> What does the qemu do in this case? Crash the VM?
>
> Yes, I don't think return -errno matches what we discussed for returning =
-1 on read and dropping writes outside of the device memory.

I tried to replicate what is done by vfio-pci core module in vfio_pci_bar_r=
w()
where -EINVAL is returned in case of e.g. the access offset is outside the
BAR range.

Such an error comes to Qemu in vfio_region_read/vfio_region_write() which=20
handles the error by returning data as -1 on read and dropping on write.

But it seems that we don't need such approach here. I will make the change
so that vfio-pci variant driver's read/write explicitly reads -1 and drops =
writes
instead of returning -EINVAL.
