Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55F050E764
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 19:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbiDYRiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 13:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244090AbiDYRhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 13:37:45 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53C86FA15;
        Mon, 25 Apr 2022 10:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUQIBTENsqHksKmlePu31M1FSv78DXKFKEPMcafBoCAM5Q8sJ48pVgC277Dp79aqFOxgFi6qlv8n5zXz7vJM5lZxUqIZ0jZHw1l9lpsYzH/UcPRlRvZheJkyJxx8Sb8TusOXiRr47h8dpubITpRNcRnZ3BamuAaMUH3lAAzyvlldXL+FBq2mpO3NddhKL9M5H35PVQE3rCJaOWLc8Lz8EeSOVYNIGDklay1nHS2YqSR9p1ZLUHOLjgOc18u9oOxrpwLdncoLzcopW03Asx90B1PitETG+nf9kWGgvtiqNChc889Xu+1ijHVbsdk6KcO55uwmnuZt6lNROBd/9qoxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyCFs/9kObdnsEh9IhLSU5L5X0yzjkm6ggeROPEfx8M=;
 b=KpDHERUluAMULfEkGOrDahVvbYhnBssxWKSnoTkiX+Fm4h6Z9dtro9BshG86nAA90mHDRIHW+H+5tmoIgFt8C7sMBpk9e+fGXSOt9P/i5vAT7XBJPGXgC++hH2+x6aTLHVjdstKp1HGPctK7SSVrli+TCAETTAh5KAj5xl4haCPSOWxM8CuA7JCxc0Noj4BUtlI5WHJMkGD6WJAvgYOU7FIuXU/C2CkTedRi2fZGhXjr1pV9G1vTLD0w/q5O77nUoBQLGJMq7XnY960tAaSUsKxlS9UjzlOepq4uXIrhQZ9SFMKh4OiB4FeWX3RQOPo3ilNbYGZQnJeLGNjRmWZNig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyCFs/9kObdnsEh9IhLSU5L5X0yzjkm6ggeROPEfx8M=;
 b=PYB3zj883v/3NSGLrmXkV18r0UzkANq8RvFJ20or5NkRaC3EK4fVvBpwoWjT6Ixh4XyND1RbCdTZz6rXT4iRSYufYuCJzVMKhkKXG0jnzKTMnmzfamgWrMe/BwFBuO1LvaeF+qWHpZ9jb39XSNWhfGlHs04H8vNE7kGsago/+V0=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by CY4PR21MB0469.namprd21.prod.outlook.com (2603:10b6:903:db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.4; Mon, 25 Apr
 2022 17:34:36 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%6]) with mapi id 15.20.5227.004; Mon, 25 Apr 2022
 17:34:36 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>, vkuznets <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Thread-Topic: [PATCH v3 07/34] x86/hyperv: Introduce
 HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
Thread-Index: AQHYUAJtfXLi4XUjsUG86ifscbB5yK0A13uAgAAc0nA=
Date:   Mon, 25 Apr 2022 17:34:36 +0000
Message-ID: <PH0PR21MB302548198FBE43E7D51FB154D7F89@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-8-vkuznets@redhat.com>
 <20220425154721.xunncuuuzs55nwc7@liuwe-devbox-debian-v2>
In-Reply-To: <20220425154721.xunncuuuzs55nwc7@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=94b7bd67-1daf-4f9d-8231-3aff00339454;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-25T17:30:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c9a6a40-b15d-4829-b315-08da26e1de4f
x-ms-traffictypediagnostic: CY4PR21MB0469:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB0469A7BFFA033094D79A4365D7F89@CY4PR21MB0469.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dZMiq1HENwo863sXPOXGB75kZIh//cBombTb1BfGqV5Zq9mBx0P7GbFuDvY7Ec0IRgiNafWj2roFzkVViAS+cT7rhxoTRwCClSu6yrNzckq3fPOfWZB5jaKYxDmENzNhUWEA1hVu+90MfbbkHVIigqzEBoKKGQfIcDP8ySXGl3DuqPPOpDjmfToMeS9YQJSxw1jujET+RbDEx40yZg0tCeUaO54bpGbKyplFsJzWMTzwqrw+TF/uZW1IBysXghWynmGhq3obTSKazyrd5onCRa6v1c1O3fSm12FYZREpGGRkd3gQVODDRiK2yCmbUo4izyNBEWvc/o4nk5UpzWujyJFZlfvwM8akYmcHqzuPMBtIn7n4LeC1Ie+IsFkouJiCJAzKspB+gm4nlKQUhTR6D7gpJnuVKvugW/zpCEdJM0sS4ESx7Y8BaXenjNuORCXFPGk2rhZ5QkYKjwK32cJFrjLp/1+Plnbdyq/5CVav8/GF8FtkkGozOFdCPS/gKJxrs6FCcnsrvMXJFrpHBS9bnalkiCsAWFMIT5z6VnHR4lIg5tByT8KqZyasrG3hSMXGRSKYh+xHJoCYIxDzQkSe0YjEQbe9C3C+yFwaBv4PJ3mB+HPv2gpinLf8iBi5X++MFuAGnV9VmTLlabb7B0z8BZEglShsnR8xN7Oz0I6PJwUn4hPS5qPvxL/0mfLoTnaUCWJv/LTJLBc3LfDOmu38I0KD9J2bU7a0miTvIQTuEEtbPR1SqSqotA92x6ygs13Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(9686003)(508600001)(2906002)(8676002)(52536014)(4326008)(33656002)(7696005)(5660300002)(7416002)(8936002)(66946007)(6506007)(66476007)(66556008)(76116006)(66446008)(8990500004)(64756008)(86362001)(186003)(122000001)(82950400001)(82960400001)(10290500003)(38100700002)(55016003)(38070700005)(54906003)(83380400001)(316002)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nGIsru5pY8BU/ikvA3nai3jjtBcvjrPiIAcnJplio3++Or/wjGB5FbaBwpBb?=
 =?us-ascii?Q?VGCTzE82U22FdimGJKq0qBvD02cJ/3DTMnpYtQAKKvIo9et5tsu/3gV9kJvR?=
 =?us-ascii?Q?5tUIy3o2OQDj7xvUsuZ4kb0DkizxHvC2ZjBajulRWNLpe/9+g2yrpJwzbiVK?=
 =?us-ascii?Q?hlT5RZITwaQIV5H7jcVUGj+JVA+kWbgUwg8kndFxLFYUlCnhko/tmT2AfYyr?=
 =?us-ascii?Q?WqB/Hw6YQ28UxII/WJQ4STVxzwuGUHXUQoLmwzC28ePcIXVuolbF4RPY/kn7?=
 =?us-ascii?Q?ohzuNinumXJ2yUwYjEoyFNv4X0/VeIocz+VyJm9IkGP08ceSp0aw9lICStmV?=
 =?us-ascii?Q?RutZ2k6IyT2rErWb8YeKlGUtnAgsfsEhNKFXpYXucYHb+8yA5rhbUcrSQP97?=
 =?us-ascii?Q?a9EQweNOf1Zpfr+kXKVHg+1F78dMj1EMsaoR3QtqYSV4ruJ5dlM4gNhdUtbG?=
 =?us-ascii?Q?Lzu9w8sHbfcs+fM1qMHadT8XyCVvSGpP8T52YueTJ8HECvbiZ5FgrsOhtfJA?=
 =?us-ascii?Q?vdIzgXUcYunLLxajgHQ1OGSjC8qjNMCi9H9qLIkzTdfwfpYj+C0DvhwLPEe8?=
 =?us-ascii?Q?TLpbwO7i57ntjvBRtdVutBafiukNZKz+Dk+QVutM6v79dGq9PNBXlF40JnHp?=
 =?us-ascii?Q?UUONJZc8kzEVLxqFdD1ofY4N/dNLiva8MzzTJLohbzUNxgIpZh/5u8hPBoPn?=
 =?us-ascii?Q?ph+n8VenAmC943vE1fWisG3qcqW/Saoex9NFvcSGwoEPtvDR5QhV8FKTNTQ5?=
 =?us-ascii?Q?SWAOaa4nXdkibTUbV/gIoCX+g3/vSXQEiUvbl1RUO1Hn7HgGgO5uJ/bNpy5B?=
 =?us-ascii?Q?Dro8FMJQEC+mxRyoqOT4aI0qlzrG+jzWn1w04rV4dqS3sZMxyKi7sqZiCLBf?=
 =?us-ascii?Q?cLYX+sZYAbl4kKZj786mk2WS9OV3ELP2C/0DBRW9kWW6JMj44gBnpkhXNdB6?=
 =?us-ascii?Q?rUMU5fo/dETuOmk312MRaYkGF/yCqIQuRkBIQ1KqVNHO1owyLK6M3gPFEJan?=
 =?us-ascii?Q?kXscw2u4iTssGklKLLCXOn1Ext41SiOw3d8Py7/2AWQ+k0SrQt5s+yPVz/iu?=
 =?us-ascii?Q?roG9iQhaBr0MqTq4o9zLK80UzaHPr01+U8fdWy1x7VJ4KBdyStD/dpRhHSlO?=
 =?us-ascii?Q?lnbT+e1cTRoUxIlfQrOCaBNEzFzliePeVOw+4i1+d/texXEgox2btWU97Ihy?=
 =?us-ascii?Q?QFDZIGeH2krLRmv4DbIdHXAhet+u+eQXhftYDfQtD6O21vARQhlyKoZkd7h3?=
 =?us-ascii?Q?GkNKAxVjpYje83+DKBB4cD1epR99dt0qcXYAu4hg+p5kInvmWNzm84NHcfVs?=
 =?us-ascii?Q?CvNEgxaWZTzvkRXHgbP8sTW9BvJabdNOMwcwTF6jjO9iad5Emci7ltUGCmDl?=
 =?us-ascii?Q?0OPWy+qWxEBkzJSUVamHloDIVYcR5jZW7bQv0apa0Rjv9yhcbGPwRrR1OTdW?=
 =?us-ascii?Q?ALtWWVB2D/uUOa3R8NDHKoT+6D6ahN4y34NCGdtPRhez0nSTMPva3lF1pE3U?=
 =?us-ascii?Q?UEc2glxF5XzjGdQBt5vMMDDCa28fXsEXxdIWCl/s6Ew1V7ilYHbjgxJATAxR?=
 =?us-ascii?Q?yR1XbyRzvJ0I6mfFccpcy5Wo4c3QSLDFOHS4G6Qt1i119MhD1OGLSh8fOrvA?=
 =?us-ascii?Q?Ov2XJ8nB9NZqOk1/FLEpI7k4XR5dZ8r6uNiU32oXXij7b6N+2MnFzSAyiHFi?=
 =?us-ascii?Q?E2ElMrcdyNB35QYVHC5/ubudIYSHASnltxBtVXyi3Mb43cQLmYfX/U5/WkgW?=
 =?us-ascii?Q?BIn/J29IkyhJ3WR68jLi2v3dqmPBxZA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9a6a40-b15d-4829-b315-08da26e1de4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 17:34:36.4908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AlPkxRpexLEu6zKLS0+lRoY3TuYGM4n+TeLGd3mi6aQ18Bji7buL3rScDWkcrdOyoH2kN8yBHQtqUkfiPiYqprSD7j9pObmQo8kxbgoeZPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0469
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org> Sent: Monday, April 25, 2022 8:47 AM

> On Thu, Apr 14, 2022 at 03:19:46PM +0200, Vitaly Kuznetsov wrote:
> > It may not come clear from where the magical '64' value used in
> > __cpumask_to_vpset() come from. Moreover, '64' means both the maximum
> > sparse bank number as well as the number of vCPUs per bank. Add defines
> > to make things clear. These defines are also going to be used by KVM.
> >
> > No functional change.
> >
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  include/asm-generic/hyperv-tlfs.h |  5 +++++
> >  include/asm-generic/mshyperv.h    | 11 ++++++-----
> >  2 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hy=
perv-tlfs.h
> > index fdce7a4cfc6f..020ca9bdbb79 100644
> > --- a/include/asm-generic/hyperv-tlfs.h
> > +++ b/include/asm-generic/hyperv-tlfs.h
> > @@ -399,6 +399,11 @@ struct hv_vpset {
> >  	u64 bank_contents[];
> >  } __packed;
> >
> > +/* The maximum number of sparse vCPU banks which can be encoded by 'st=
ruct
> hv_vpset' */
> > +#define HV_MAX_SPARSE_VCPU_BANKS (64)
> > +/* The number of vCPUs in one sparse bank */
> > +#define HV_VCPUS_PER_SPARSE_BANK (64)
>=20
> I think replacing the magic number with a macro is a good thing.
>=20
> Where do you get these names? Did you make them up yourself?
>=20
> I'm trying to dig into internal code to find the most appropriate names,
> but I couldn't find any so far. Michael, do you have insight here?
>=20
> Thanks,
> Wei.

These names look good to me.  The "sparse" and "bank" terminology
comes from the Hyper-V TLFS, sections 7.8.7.3 thru 7.8.7.5.  The TLFS
uses the constant "64", but for two different purposes as Vitaly
points out.  But in both cases the "64" accrues from the use of
a uint64 value as a bitmap.

Michael
