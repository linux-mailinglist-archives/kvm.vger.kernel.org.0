Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F5C7AA259
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjIUVPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjIUVPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:15:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1075FFC
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve1BahMOTIKlXQbNRxI/PiqDnN1bDV/eK97ZRocnwWydUWQe59NSUkkBY2VIyl7uxkXLBG+o81bjpS6I2UzFwD3K0aU6rm32Pgn+KYc5zLVOwDrDyYjksQWWJVg8t5LTpBBVuw6sXEwZ6u6Y8xSgzTNIcfdvTViw+egWFO/oXkWDWKSI9GFTWYvkdaoKPabOw0TgV6wLjPAZ1llOxSkYjuxeSIXqSMA9A/zBZPyubzWCwGm6dh9BmTLLtrFQFMpYngWFXfxffRZlki1rFYEGVEG82cDVwBHaTCENLlBDwRGnc3/0HeeHMufkYkU9K/cBK/YQ8A1L1ISkGxFOXlip+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hspoE7rP7AWqQkP3u32lWkBYABu7ccTe9qqFJjG7sYk=;
 b=QDAKZeWkPD1ZB4yZKM87WEMuKbTwxULgYMGrLWGjfPXCoPLn589WCciliFPxvfYZ1DWzB53n7f02UXfM2zYvDa0CYbusiLTQH6HM2b6f1540pnv4QEazCWAGGhwh51ZReqrrmcyLBrTvxCAlNClu3GkJ9DLsRp/1pxzU/c6ihO2WfMCCt46q1ZdnQLYof0k/RoG5lhFy9enHujPFY82c5ZCy23lZ8MHj4yFVNpaS9nTgJkOZeZj8kBJRG6J7v88DkZMeiVN3mVxs+rS52i+NxgKKwAeSAJZGRdcGLa6/UImc3endoI2pew61fU6RkJL3G7QpIQhKyBOSHjaW4GwJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hspoE7rP7AWqQkP3u32lWkBYABu7ccTe9qqFJjG7sYk=;
 b=g/CPQ13rqRAGrdZC6poYkyDfG5qC1MCjeIRVvMenNR7TqvAF4IrlXQHkm67X4u+t1xrLnFw/10bgG6mCEOfhaQzas1p+S4Mx0ELpdNHFxL/tcg4Zp/A4ykXIN7FK62R0lwEu9zpbisrRoX+UhxVNRRytwM/6rnBi5PSTX8P9/bCO8NA8bkOue1yAQs6yfdtMixTGkWUA0iRij6ClXoQjLKbbsjgXHrw8VTuRZbfbAt4NcWbdBwcIm6nC7xQsR/hbdiApftCyEYp+nONnIOxqvon3pIPlmKT+X0oRLXmhrMFmtGNA3kbT91l893vBUvij/OO8tK7+TnuU7OtX6hj4qw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by IA0PR12MB8864.namprd12.prod.outlook.com (2603:10b6:208:485::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Thu, 21 Sep
 2023 17:09:04 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 17:09:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlfIYAgAACZQCAAAJ1AIAAAZQA
Date:   Thu, 21 Sep 2023 17:09:04 +0000
Message-ID: <PH0PR12MB54813216D57AD82FAC0C10A7DCF8A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230921125348-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|IA0PR12MB8864:EE_
x-ms-office365-filtering-correlation-id: d1b7a345-d082-4655-8789-08dbbac57556
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wJh3XaB5aYqJVgqyaRZxn7o5F42pRoCwC2iIOsBOgcF/Y0YCp/BsLvv6vz1yKlPj6GuMwp0RE6gS/vRg5HGOPniRCQULdviFBbl8hULy8twk/1E1yuMqh3ae4o1vP01orGXpcT5IuC4L6/Y4YN/ocSnt6fMvU2eiE6zpEapXoSg7VjjQlTnXheGBxPizns9euexh8LNgYmDI4pvS4arxc+ZVSFMIqF/JxvkGA+3Mwj/KbXRWV1fPc8TT9/l2p3sUZzUWF8UyFqIf2OXMHOY+EQN300JKlcVDx25EpKpw9eB5/pa9Pf385EsUNanRqxMSs0LsnqdnpyVcpc/PJY+P8UkssEYkKaIQxRMDN6Q+F0iFLW3tshehWEwmYl3MbRMBF/YVthdo/2ESK2F1mmFTbT+m3y6CmZztrdTzfkWvQOyjztd2wfKPE1RHKEfmUs/3Yp1gPS5reNVMiUoH3cDV8VvbStYeJXTU54zKl0j+kR0kIENnLyFUMt8nWfwS7trBCROF4FxGyHduJEtWHlp/5FB/jZAIejgd9ez0kI8mGtQKA8DIetkk8aHe1eSiqZT/WJLtCTTzNoBuAKIBl6n29kPbTAlSunbgcjFgUhzE36rCr/3rNibB1IjEKbi/O7Mj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(136003)(39860400002)(1800799009)(451199024)(186009)(2906002)(38070700005)(4744005)(38100700002)(83380400001)(9686003)(107886003)(86362001)(33656002)(7696005)(71200400001)(6506007)(478600001)(26005)(55016003)(8676002)(4326008)(8936002)(41300700001)(64756008)(52536014)(5660300002)(122000001)(316002)(6636002)(66556008)(110136005)(66446008)(66476007)(76116006)(66946007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DyqO4xsH1/MZ50LmJlzDVHUXHmvBd8tJqWlAtugen2Cl76eGUSB4B9qQiyql?=
 =?us-ascii?Q?NV7VxqLb5Z6qboKW70es8LIU4nZRouGpdgU/jWZxeX0eJJhIWxIMu85SJMMw?=
 =?us-ascii?Q?Ph4OqegK1ecLNkhM7Bchgygv789g1jz1z3ZDVEw2TJABA+HTtqIhTSKl+JqZ?=
 =?us-ascii?Q?WC1x0ZysEdMbkECtvNfiSIRs5lYcFFKYYE5kBOvswSc6NZoXs2Y+DaOqJNll?=
 =?us-ascii?Q?l0XG5BvzXm3ciozB3WdBBTDolONkHsYpS2WntPfv4D7s9cBiKwUEqPgOt3R3?=
 =?us-ascii?Q?jJX0DC7f9e0J0iKnSX8ZKnbJlyS61d8ZkUw/AmvfGclhW9d0qcfiIBVUb6v2?=
 =?us-ascii?Q?AdUbv5J198IgWG0mspMhGS+oPuoijYuLYPokQ8pby5ZP+9a3AAFxgJbuQk+U?=
 =?us-ascii?Q?cWeR4rxNd28beg8Hl9x4ngDs7IGmjaslNnIv3/X7wF+87P6/+M27MY+c4L42?=
 =?us-ascii?Q?vePRyHYA87VYJXEvlWgud8PnybJFwIpCx6ww81X3k6xcjoMCLC0aZsHRnQF3?=
 =?us-ascii?Q?vdnHOB7ayEhl+5ub3nEyqVLFnrz2gpWRgl6A5PSrRvY5FK3ljHlVCQud2ZH6?=
 =?us-ascii?Q?elI0dVJg+KJkoZns/a8yqKqte+pigX0dnVVmergAyBUcWXMS3SAwqU1u5N48?=
 =?us-ascii?Q?acCHj2CconDJEqoaFCHLpz2IrxmE14XINAU9j48GbPWtuL3nainbkRDFnoIE?=
 =?us-ascii?Q?OTnN0CYWs0rmDGNtIh47+Xw3Xe3AcxW3W1HQHAy5kntiOfssp5oR4WGBowrk?=
 =?us-ascii?Q?hYS42dm8FwlfCAv74i62ZRLhNBm7uchYhILGXZZb+9f3nnMTDLul7lTq38CW?=
 =?us-ascii?Q?XDb+JPxpRHdz1liFn2jzhUI5yqQmprqMkXcOBhGIYp0/seVHkbTs/rPvu7jU?=
 =?us-ascii?Q?LSwRYJW/eQPi5chvBPvGKMiw+WR2RpqV4KfRSOAOh0bMk3HIfSEqJJjRLSqB?=
 =?us-ascii?Q?k1TJWgO4ltPdMnhNg3Hkq31p4tIYDz2I9H6+YLHlj+GVXi73nrIDiAP79bko?=
 =?us-ascii?Q?NKNCceafcsBdujVruFxMU7GbnDsWglZCZjAC0KSuwGcDRsHb4HU2q1IH3yZl?=
 =?us-ascii?Q?gbOCvYdfaRkFQLi/mH6zIIFh7s/D5CLqzMNI0B6Fig065TuI0dIyjrKEhjjU?=
 =?us-ascii?Q?MLD0jnjCZYmeIK9ZlkH1jhPk5O/WSdbfRa8vr+97tmzpCEBnSvGoq1NcB7fD?=
 =?us-ascii?Q?9/mIaRGnI3WI3sKiM43g0zU8y2hK8jqqG+soXRFUoG95oFupYv6OoI380qfL?=
 =?us-ascii?Q?9C/1kfzT+BLGOTqH972VgDfUcmwaFa5fzBnOSHm+GafgxJ1pu7bCGKf1ZSda?=
 =?us-ascii?Q?y9EGkJJgjx33CbIs4J5V6gS7D9zc0GG1ZVxVPLoCzJrraRwneeC9ucUbKfzw?=
 =?us-ascii?Q?Zq5pI6J1qOYuZWng4hkhfQgnL3mmB1cGGTgJ3LxeqrblUpPqStlE7A89Eb1X?=
 =?us-ascii?Q?z2CcJxp+N5AEMnZppc1gfYRoUy6lAAdNMmxg6fgAiCgbLD/B/rCJfrgGWSCi?=
 =?us-ascii?Q?NYC9KD9k3p+iL2vuZjAGJnZ2ju1OmXWan4BwdV0elfP+r0Jdd1vs8ieOnlcu?=
 =?us-ascii?Q?5WgLZs2YvAVOaXmSV6A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b7a345-d082-4655-8789-08dbbac57556
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 17:09:04.2436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dl3pQ5NS1YElZoKyTLm/7Nux2Wzm/dL9xbYSSeKnPjOpz+kCK3fbu7jYK2zqKxC9meLO7871fZ8KE2usIA6Tow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8864
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, September 21, 2023 10:31 PM

> Another question I'm interested in is whether there's actually a performa=
nce
> benefit to using this as compared to just software vhost. I note there's =
a VM exit
> on each IO access, so ... perhaps?
> Would be nice to see some numbers.

Packet rate and bandwidth are close are only 10% lower than modern device d=
ue to the batching of driver notification.
Bw tested with iperf with one and multiple queues.=20
Packet rate tested with testpmd.
