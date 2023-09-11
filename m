Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E1179A5D4
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 10:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjIKIRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 04:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjIKIRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 04:17:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F7ACDE;
        Mon, 11 Sep 2023 01:17:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAM8ehjCPZHG29mEIsvZQ/RCBzAvH2MaOZ+/bB2nYxpb0oINXay1PWWiJfNxVQYu3Iws/69WuVEBUgoq+dNdPLZ46Jftpb7tdfOa0StS/fVuRszPSS227OvL7h5cCJq95MkLF/x3eXkwpHcgruTK84VP7yE1sw5k52DygqLH6n95/PTT2rKimnuHGEdD6wtBe+xT8/290n7Rd4He2e+k+PMbmt9wEzAeGsO6+rlUhYy40wYGo71BKNJDXrV5YZ0wPQkQp/PM3u8Pxqbki1RQibiNYTVqRSiQeXrP1kozcpQqS2PTTg1Gqk1z4sarLspxPG2Zcv6Zz2UEB/tmrqcNgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ksF+wG47CxhTtPSSpDAbD+cG2q/zOxT/WFTlvR72Xg=;
 b=Fzy+gBeekZ5QoSIzJR8LWtxMBGkuTsfyhi6zRYn9vH/VPSryVG3BbPDoP2jZgqW1ZAv5S00fM04l5ySsj9Z7TOFa2wJI3CiX9SqTRLh8hBIW2n1fCgPcfcmpAsc55RY7lJzP48k1fhJB/pj4DyC6oxMNquFgQgjTz1ebFmpGW4j5yIJ1lWKS0a/yl16xZ4vRIxfInNV8V+fCydQfDjdEe+RcveK+pGvo9KrsTe3xbZG5/gYndNwAXekFaIcSLpjxhUDPQcrOVnk14u9engyi253scsqcbU6k592BivygoPsLa3/srRzKQ+3OveAVSRCCfifvcESqaExQp4yfJA17ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ksF+wG47CxhTtPSSpDAbD+cG2q/zOxT/WFTlvR72Xg=;
 b=g1pVnS2JPe3iBc7aYIqFMSomHAheI+1O3Zq0Gvt80t5QssusvAxZSfAs3lAeN2yP/YDJRUFrH1RQf5mpgVsUshkx+8I/ibfzXCYcypwyzCEz1+QUsdHTjv87SYJcmz5RZjzD+3NgWcIdP+3y6WJsfAXn0MYdCt7H1Sb4fKga0ZmQk1wtMGzi/bSjGOpugdbHoTugYuxI14Grrry/xifFOB4PlAXc5Oz+XXXYXuYpCRSarsw5J09Pmc6VsjE2R0c67fHXLXSWtafeYss3kBIAVJtq9u1lBoyt7KgwXTLCipzfWHy82pFPfk/USJ3G3e43LJJM/0colDNPMlOUY2JmRQ==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by DS0PR12MB8503.namprd12.prod.outlook.com (2603:10b6:8:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Mon, 11 Sep
 2023 08:17:35 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060%2]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 08:17:35 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ11GEd4uKBig/Bk6gFqMLb5fS47AP2/IAgABN7YCAADqIAIAAUAcAgAA5YoCABGIpgIAAEEZX
Date:   Mon, 11 Sep 2023 08:17:34 +0000
Message-ID: <BY5PR12MB3763D6DA3374A84109D0B2E7B0F2A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
 <ZPrgXAfJvlDLsWqb@infradead.org> <ZPsQf9pGrSnbFI8p@nvidia.com>
 <BN9PR11MB5276E36C876042AADD707AD08CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276E36C876042AADD707AD08CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|DS0PR12MB8503:EE_
x-ms-office365-filtering-correlation-id: b210b13e-9ef7-4ac4-4b7b-08dbb29f8daf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sk4FP0jpItYOplnXm7UtEljF34TdTwMneCvRMgIlg2g8Bo6yahLRmSe5YBKgJIJJTmzlitNjHlrXjXg5NVfUyE4mP10Do97NKtgOmYvO4nSZBujfQ93zDEBJIATipm+iKlG4N7qbwox5hp8usdQdfXIDoCGk00NSPimcghQ7Se0hGnR+WMKpj2SQ4AOIFm7ZVVD9mI7ISXr6qBlvKSvR/5H/oPrGLVvQE2OJojp7kGa6oTjXgJBQTAh0eB++/pxS0wpFwpiEg8MeqnDZXZTZ4nc9ZXZoPYaI1U8K2DA+DTwhxoqnrVnbxLw8RFlOixHdx7ZuoKJU2ffKiISD59LGqGBeVIFlmPjXD3b0FVLUXXTFelJngCMNj4siITyn463RzK4eXS4FTd78e4pVJ/fTscXBzNFB7LeUJN6WrdrurJopsiiXKCoALMoiT7itdY/uneVW8cDaPXXtwa31AxV037v3mgYapbk3dIBlUWSBGUOVYmUhiXwajr/ZIGRRV6fVD+E6Byy8BPmRS/sd4mPtFGdUjFez399vt45x05jJ+8uS1XiCztWEuzV5SIgDyrT8rI9aNcYL0rehV9ptyXY6fl1muot0sLxBqomhlK+CO8BIqpHyQGA1Ma9wxkcCeSWrszxTK61hOTjYuzfNeGQvKYkGElYY4rpwuV7/6EKwR7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(376002)(346002)(451199024)(186009)(1800799009)(2906002)(52536014)(26005)(55016003)(41300700001)(316002)(66446008)(66556008)(54906003)(64756008)(66946007)(76116006)(66476007)(4744005)(110136005)(91956017)(478600001)(4326008)(8676002)(8936002)(5660300002)(7696005)(6506007)(9686003)(71200400001)(33656002)(38100700002)(38070700005)(86362001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?S5Ta1LbF5MdPB8dnIoWfCj5ooNhykZYXJv/y+v7Cow/dfeU0wAFuN6WVmt?=
 =?iso-8859-1?Q?hWpeqe/rDZz6NcQF/LY99rAGEuUY3TBY7k10iiZwfkZWzS3usHhqDdGDgo?=
 =?iso-8859-1?Q?NGxnVsRU0x4chSEWxqnHryprmm+emrB5T25yAoQg6ZJE7D3jOlgrIgUvUJ?=
 =?iso-8859-1?Q?NKwliU1ppK0kD7l6PuGpPB75BEGDYYS6wz3aKZ04y0AiY8esWRKPsaaRGa?=
 =?iso-8859-1?Q?dDl2nM4RH/jvtGFLLHEmvqVRje1nIIAG5s8Z5/GCWkVTRDWRo9ZTS0wqYe?=
 =?iso-8859-1?Q?mj6rIlowacdcBLe/Vba00PSXSLd7mdFPPNUp6KdyuFrqkCrTdUmOq1/qLD?=
 =?iso-8859-1?Q?6pYeqBJ0+2nO6dgW0Vd6jK//3vrYKbTfcRyGCxC5J3T0PQcdXRJgNF8x6I?=
 =?iso-8859-1?Q?mo2j23o5n0jyum0PasGIhwJzUZYoPS7B1KT9aCRuysLnapYBClURUSgsjg?=
 =?iso-8859-1?Q?/WKDLIlwAULlpMuAFP1tMWk7B0HRSZoQS3PnaV//e+dgwqKyzauu3N6wtY?=
 =?iso-8859-1?Q?XwDcB+hE0QR9iEsGNz7+1yM7QEca2NfCvPvQ5HJvcq3gbms0d4Tk+DHgWg?=
 =?iso-8859-1?Q?xBbyMFQcfPZYZSbmd5y9rucHMSOXD86Hw4yaV/r1ktWE3hSiiatXvAmkRE?=
 =?iso-8859-1?Q?c+NCUkMa3MFkUS5KZY8bSIkkxNPDqAiBOvLpyBIBjX34iqEtPHfhvi1aKB?=
 =?iso-8859-1?Q?w0UXoWH5sDm245QDkiCdVBJQlCzQko7HYOHg8L21YsPeWbHjjLEzTHVxtE?=
 =?iso-8859-1?Q?eBdReXZ4u4LYG7AFm0klcLP4p9+bP/uvtZck4PaEhoyZ8SeQ44SnS15hL1?=
 =?iso-8859-1?Q?hwV5e2dfy3PH9X/SQShwzpdc/2pI3OaDwd/dseH03i9Vtfk/eiOzWDJd4C?=
 =?iso-8859-1?Q?yPqR4oj9Iwvj50lWTmki/ZTzIoEPux7SH7Hxykwo3YDAiFXga8733zeyn2?=
 =?iso-8859-1?Q?VpZX+tdhdIOAfsAVjFFJHEonawgCAmCAgU4gjZenijZzO3YpBQAgFdpkSG?=
 =?iso-8859-1?Q?bxG/g7XOQjWOVRavYuVkumIMqiQBv+IJZicMytCPdZhSeTmOE4GyzMrYpj?=
 =?iso-8859-1?Q?5gPOuWCq7HYoME9FPCws74ZyQlxFP9qEWhbaPomvZKKVmA8F0xGEDHiLE7?=
 =?iso-8859-1?Q?UJ/qnZCdTeDrQV/VtiroF1jXOTUYPixQfdyoLvRAksc9eM+TF2/vlAf1ze?=
 =?iso-8859-1?Q?NXL2S1tAxCj2MeaT9QjLTehAPo4XERyLe819+i4A/nreJ81gOpZJ6s0uZn?=
 =?iso-8859-1?Q?KEMtoWpTl8FEiiU4zD6orLCLW7dVqfr/WRTqSHZNvF+PBTI366KT9OXQaY?=
 =?iso-8859-1?Q?soFmp/2Qu+GvqiUuV8iQpuTQ2RCqH7UOIpZeYscJ1X1WirYh1GD9VY6Ya3?=
 =?iso-8859-1?Q?od9CvlN3gyhNzRTHx25qtv7CyU/OmfMHOYrU0RlJ7G+DDC8XeQuABSv8IW?=
 =?iso-8859-1?Q?FbhSUVXeUPEiCbeMNQQdzAKnhN2hN2igTYb/W6JccRv8PQC8d/FBqK2Nqx?=
 =?iso-8859-1?Q?jtDZGgkwA2Licq4jxqLY6IMjzG6r5lVXqEXJN1KX6t1kDVGSOMy/aP+Q72?=
 =?iso-8859-1?Q?/E9gg5zVp6tRPilUAmRjRSMgtnk3fJONj8ZnC3uAzJR78YxlZdlwCNGLii?=
 =?iso-8859-1?Q?52BgpjPQnc+8o=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b210b13e-9ef7-4ac4-4b7b-08dbb29f8daf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 08:17:34.9207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pNdgbrhJcfljmXr2TGZplQ+/7u///h3TI20v3ERRA7r8kQLpvJVbY9f9Ei3vyeyizdMSgdE4f/FcvBKgk7J0QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8503
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> I don't see the goal as perfect emulation of the real HW.=0A=
>>=0A=
>> Aiming for minimally disruptive to the ecosystem to support this=0A=
>> quirky pre-CXL HW.=0A=
>>=0A=
>> Perfect emulation would need a unique VFIO uAPI and more complex qemu=0A=
>> changes, and it really brings nothing of value.=0A=
>>=0A=
>=0A=
> Does it mean that this requires maintaining a new guest driver=0A=
> different from the existing one on bare metal?=0A=
=0A=
No, the VM would use the same Nvidia open source driver that is used by the=
=0A=
bare metal. (https://github.com/NVIDIA/open-gpu-kernel-modules).=0A=
=0A=
