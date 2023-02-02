Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F5A688829
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 21:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjBBURJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 15:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjBBURH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 15:17:07 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508334A22D;
        Thu,  2 Feb 2023 12:17:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cn2gq2BFKKFxxzkfi5ujCybynsoE8A6V7zMKx3grfqCExEkoVK2/d7K8ZRZcO9nzH9JDLPpmlbAHM61DzMErqi1ZEhwV5zLycjEI+XDYTEfa+7IiygnfZQ06oWC8+W1BY55XQsxJdB0pw41VIsCah5i1uS3T0PkNMs0gYlCUxOJs7bJnNd4LHKu/pNGnVnBvsbrzTQLZyrsEQ+GhirLJqGVuScZGoB0yYwGH1rNeDMhYdP4SBF5ZYzxVwCBdhv210sb/bBlvrW/Fgx0fuy3w2N+Zx0nqlTWCxxnOMZrxcEs4g3LpZxsgHZ8rnn0/5DRzVRqmCgiUeJkAtJtTeww+RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSB4Rlq7s7H6db2Oa4aCz1rvNwt/mXscfYFoPibOEak=;
 b=jQ/dWCXe5ha4g68zuPBKE452wGFE7EC2lvD9mZSKS2kdUCBeOlhuSlsF2Evl0DcTxiUFNxYBNaIAI9ody0Sus8CBplZ2E7D0CJs4JsNsDOp3Z0Ajx8bFiXF4H1hilHRLJqDYDd1JDwfWmkc1SSVJQEznUP4UqoCxJDaodRMONJSN3RaLjUy1ns3SaXzK+XbWGZEkVl4NLjSesKlZgIs+fcM2bGw6sl3LnuKn5FPuJH30/kKRg12xOYtb9sybBFd/1oMedCZkWC2QAgGWFehwQa6uSKXr9Ku3FA4kQChqDNJvwIbOKM2EVRQwjhBNNblQ5JPrZd7SfbeK8pHq5j1YTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSB4Rlq7s7H6db2Oa4aCz1rvNwt/mXscfYFoPibOEak=;
 b=omwaAX0S52ftbg/QQK85oPT+31Kaq07Yr743Vb2G6kNScjXGRgbOvzdLPmjqCywU8cA8DSxmwjPr/6DbG7i12WrhiSo+ZsZzQBqGSjOxjgBTiyTAkyIFTA4XebBQC43GB8vJE6BdpBv4wsOYWhdU4ZuMHjO/nnP9CjXpfR4JzTfepYK8JXOZnO6xOyLe6GJc8G4mc84X1j2Vd86PUA7ZvMSQmjv4w97rGyY+HB6BllCGoVDxOhEfKpHF4aVwTCiNrLgtMMQPxLnlbTliMbuyjd65oqviM/hrJwsOfRYj+0/4/Bs+RRRG7xjVyAm0v5n8pDq1fHp5HDs9JCcxWgNG9A==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by PH8PR12MB6963.namprd12.prod.outlook.com (2603:10b6:510:1be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 20:17:04 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.033; Thu, 2 Feb 2023
 20:17:04 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v6 6/6] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Topic: [RFC PATCH v6 6/6] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Thread-Index: AQHZLT1DFK7gYbjBnUSEFj79Obk3Bq671fcAgABMnVA=
Date:   Thu, 2 Feb 2023 20:17:04 +0000
Message-ID: <DM6PR12MB35007ECA7A83D5AD67875703CAD69@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
        <20230121020738.2973-7-kechenl@nvidia.com>
 <20230202170836.000078f1@gmail.com>
In-Reply-To: <20230202170836.000078f1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|PH8PR12MB6963:EE_
x-ms-office365-filtering-correlation-id: 545e27da-5a05-4826-87cd-08db055a7357
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 347oMq/WlYin030ReQPeFBGy/mVI3elMQ0I7Zc00BIaFDYB4RuutjeXZiZ+Ncoql4J8drXohZG+ldzYaztNGncEkJzyXvRbhrVPdJuuTh32dAVF66eRhROnC2WtWtd3nfhcBydvQQNURSnKWhap6+we7tD5q/M9ooHWCiyPPZ5YJ0eYH583j1Xf8EKGOb26OeaM5OREQwHB/d09bjy18LcDNGZaAXMpFgahT0mSA+fMUnCasioP9Kv3ofObCNc35K7I46BEt55p5x3YZI2ApleFBZYD+17fzSf0J4sb3zq9QgoYWlc99gGloSaf9H4i1oaJdXoSPqX89aMCZfU7lb+exOrpR6/T1IL3/FoM5AoRW6HNAnMsmHFa4cs5/wcT+6IqweNiQwgbJ/Dqmmel9HsXtpXqAQCorKz9Kzp7d71TIawmocy3qHbZasPteRHYAW1xohbMq0CFbb0Mojvagmzhp50mu8lRlDQdtPuKphFxOlXP0tTC4VWcxmWQrw7rsElv/UZCmZT8JQ8Ab3IQocILYoHOUnRdnWZGCubUIsnQJbI21CDeXdraS04z21Ngkwc42THsjBi8Y9mWsPICyhaFZX4nMiLwVvc1O8G/H9SeB2qXRaC5u6kqiH6D5kpVjrgdW+WTmGfacfJJHob/nlH5TIjSBgwuStUSxGpmR4wY2+28enujPIwTUNZA6bJ1fnFZ7gzezCDtdzvVPEn3KcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199018)(6916009)(64756008)(8936002)(8676002)(41300700001)(66946007)(66556008)(478600001)(86362001)(71200400001)(66446008)(66476007)(76116006)(4326008)(7696005)(52536014)(316002)(122000001)(55016003)(54906003)(5660300002)(6506007)(2906002)(33656002)(38070700005)(26005)(38100700002)(9686003)(53546011)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RePUaHkVrncBdBCt2DWPqtzMSEeNaKJoOkhcp3hO8nXj8027BZs/GrPsdc7F?=
 =?us-ascii?Q?uVchpN5Ng3aqqNON/Bl/Ye0Wahb34bgpN6TMvUlrmfLi2hrrIZzkM8WQKldS?=
 =?us-ascii?Q?b42BUvZVOZ7lP+aJ7GWLj7tvcQgsu81X38M13rnFLm9xYfsmK+GbWc50mLdR?=
 =?us-ascii?Q?dZ2O9Vi+xxdDwsFnXAURcNSnlxyeaTG19Orc99VBRDv9LojedAejWS3OuI9M?=
 =?us-ascii?Q?N5Ha4Vnjg0/Mmqrpkigp9HeIdCip5M9dua7/NcfEKmNL3Mpus6O5a8T880qK?=
 =?us-ascii?Q?LQD0VVLlVXEPCc2hj7AFPMVuwWnhcM2o+h4x5d1m+uDEMc77pl+e3G7bDZiN?=
 =?us-ascii?Q?iSneanG1X6WSWW7uHTz6jBTgNV3XaOBvdkfmOzVIq458kcsx002CLSk098OR?=
 =?us-ascii?Q?Dmn4sOHl2KF4932yW+CgUz64IRxaMzTbxco7PmQv6BM2vAwcTe448mciUAZV?=
 =?us-ascii?Q?QcUYBrd3rGdoEh6kwauORiN4L0lja7ohLiqv6Wvjo8wLZHhUh0Fdi+m3sZ7b?=
 =?us-ascii?Q?tJauZQhLfWLtoNH9fcO7rjMQDWtZBqRcrPw3TWNPZuDLuRLU/UFbH/KH27Be?=
 =?us-ascii?Q?IsdxG9pFLijev2OnEGbGj6YKvI2L7cgl4th1A6Lx4HtCgE6ncUwBU4Jo7jT+?=
 =?us-ascii?Q?4Tbv3BiOz+M4tNljMb0713JkTudnf4l07zTOd/ef2rvH7BX9K1BrXOEyPaB0?=
 =?us-ascii?Q?oyasBVqAhihdViSJgFurbc6OYZXe1z+mNk+BouOgHUBscQp7jrrIETylL5t1?=
 =?us-ascii?Q?HoTna+pZf5ib+jCSgCEkrz3A5JeM/gUw6jUQc431/PmCuRLFqY3s7JD5Re+6?=
 =?us-ascii?Q?bBvw9KeyhRIPWHcTZUwQQQyAckkEsCc5DKcDMVIn4yAOzFzwJ+44H1QzaoW/?=
 =?us-ascii?Q?6fL95tUGcwdDH3xrCNhIRlc5+iaADlbzB9ryly3DTlXDlRtbv+6I3J6N0Njx?=
 =?us-ascii?Q?IYi91RJFUUk/he8Wc3kClXrV9SYA28XLDaYZ66h8d2ryoQHnyJbmX6KQC1m7?=
 =?us-ascii?Q?7FgTytdv0K1dpVIDoS7rJPDhU+ZIyxblWfu5UDtWRQI2OT+1iyNl/i+2pccj?=
 =?us-ascii?Q?O9M0GchUJcAGgRtXapFlYUq8GA4PJcdx4DBmeo34q6N7J4r62GeVd8KGScgt?=
 =?us-ascii?Q?Og6PHnTWeTJmfodo8Zh0Vm8dZGUEiqSXzkHlIhIHuUCenEFAcIHJ8nDtW2Ug?=
 =?us-ascii?Q?1ak4XxrLvCSYbkANZQX9QvUkZQW2pTNS98KAjvFnzcGR+TLc9mjKk7snKkZU?=
 =?us-ascii?Q?E6WFhm9nomaR9ur/qsilERI0u+aRdv+l7NnaAHum15i7kewrn7lw32YYdyCL?=
 =?us-ascii?Q?GBZFXyW2BDGYgE0DDIsZ62RQXCtWcn05lSGldeSqBt7iXnFnAiaOagsgfsmW?=
 =?us-ascii?Q?AmL/HLv3iiH3BK1tQj64ShVFUM2B3mswxTuk5b0DI0A5n1s+Qva19K0IbwyO?=
 =?us-ascii?Q?TS+kxqhwwYGRz5WkB3+8kVzuizGJC/WRTFOsjsC6DOZ8+QPxdP7z49FRuXz9?=
 =?us-ascii?Q?zihGCKZBYOaXr+zppbpIhuXTBc48TWc884FdYxg8Fe6QRL6717Grz4vawbY7?=
 =?us-ascii?Q?c1RPaE4hCJqb+0HJD6PY/v2w9h+xjr4XwJtMWCqw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545e27da-5a05-4826-87cd-08db055a7357
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 20:17:04.2743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7TcnsxdnygpXeBv2mdWzBppWJEa6gUe/atW0ovoVYDO9YkWV2jnSQkgs1XJbV9vuOYmksTDQK5TpoghzjhoNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhi,

> -----Original Message-----
> From: Zhi Wang <zhi.wang.linux@gmail.com>
> Sent: Thursday, February 2, 2023 7:09 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> chao.gao@intel.com; shaoqin.huang@intel.com; vkuznets@redhat.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v6 6/6] KVM: selftests: Add tests for VM and vCPU
> cap KVM_CAP_X86_DISABLE_EXITS
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, 21 Jan 2023 02:07:38 +0000
> Kechen Lu <kechenl@nvidia.com> wrote:
>=20
> It works on my box now. LGTM. I was curious if there is any other userspa=
ce
> application using this? It would be interesting to see their strategies.
>=20
Thanks for testing this! Appreciated.=20

For userspace applications, we had a POC with the changes in QEMU, to do th=
e static per-vCPU HLT disabling, depending on the users to have the flexibi=
lity run guest workloads on these none-hlt-exits vCPUs instead of disabling=
 hlt exits for whole VM, we saw 3%+ performance benefits. Furthermore, we h=
ad the dynamically toggled hlt exits strategy applied on QEMU, which depend=
ing on the guest stats and heuristics to do the hlt exits toggling.

BR,
Kechen
