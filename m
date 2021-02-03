Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538C030D374
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 07:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhBCGlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 01:41:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7973 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhBCGlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 01:41:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601a45550002>; Tue, 02 Feb 2021 22:40:21 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 06:40:20 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 3 Feb
 2021 06:40:19 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 3 Feb 2021 06:40:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ho/3DwWS0e4p4pFcwowTmbYl8ZRdIgRt9m4tTNnVow+k9oqnZ3rc+5rSaWeUVdf9qKNVdKzhpLNOHHvOl4MG1+yo2mFwIb3+kwnCIg3ZMpxcU6SIeQM2zGyvPC6qZVdxDCB2h3S+JfQRedECjALIULY1oWeME99Duix2ceAydaw4w3tI/26z4bTJRlij2/aMqW2ck8I708cT9RqPDqSexfXHHyeIClfGge1NJ7i9c/ISL6AtnafFgwNddg1hbc3SlYkX/9HVSdfZpEVPHOWNFNeQdb9JDYMdtS9lZvdCV0xoAiXJet7H/0KCxyi8tiZZ4LfWmMRC0sIOPNDKSF1EtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGXdMU9PCucIawNpn47Hqwyp5U+DiBDctcwhOfcr5uE=;
 b=ca2O6PU1FZYHpMKMlM1YF3VBtm9Ene3bZQ4+LDbzunIHZcoHtlpi5a0lh0xPTcOWtywBVp1yzRB31rl86SdifkI8lCGaOeCjYDbtI2azyArAslxlfilKwXJBXYnwkfUW7kMRRKUH0VQ2rGGFgrQCiHlCLdUG3qF0Y7+Y/S92+ZqgMnwZkgJVkqedOueVB6F+S/dPiwt0vv2YaXE9lr8tl73/TQbu3L6xRHIXV71Rs4Avn2NZq6o/TRkInFWxK4DHgY2fjW3juXErfj1iHr85prq3dRInIBMLycSTqI9ZyQerkmyEO/XFlWHJRvDYy0EfFHH56nDk3L3h9wdxbHoh5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM5PR1201MB2554.namprd12.prod.outlook.com (2603:10b6:3:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Wed, 3 Feb
 2021 06:40:16 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::fde4:47b0:69c6:6cc1]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::fde4:47b0:69c6:6cc1%3]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 06:40:15 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
CC:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>
Subject: Optimized clocksource with AMD AVIC enabled for Windows guest 
Thread-Topic: Optimized clocksource with AMD AVIC enabled for Windows guest 
Thread-Index: Adb59oEjzgg4QSxwQnWgWIvDOxc3Gg==
Date:   Wed, 3 Feb 2021 06:40:15 +0000
Message-ID: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=kechenl@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2021-02-03T06:40:14.6820258Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic;
 Sensitivity=Unrestricted
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7c16056-902e-4c01-ec11-08d8c80e90d4
x-ms-traffictypediagnostic: DM5PR1201MB2554:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB255463B5A4D5D1709F29FF06CAB49@DM5PR1201MB2554.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l1MIVpqs91r4BBVtzA1o71epPuwnZzyMBDYHKEIHt7GFlstHSlHvuzQ8IDCtVNeiQFDTvqVVdXKcpXzkkP4Az/ORzBgGI2zd9VsUeetCl+1C2MF5mdcaoA539zyt82Cl36s0kmKYGg5mgvUO4YQlv5xubHRWVXEVxZbQuOYiiy2FXrCQqyxEjcHZFhsDxQijppUVpKHVpOKcnLt/ynXIparQuxsmKaWgu5XwuiFW2y5vwa8wwCcOvCxWDYcMZ9nRAAL1Rh1ltVBCIjvk+iD98p4goKfbkXS43PebAWu986J4ZSoLWb0qfUKu+rBqXlmfHWJ8aYOsUJEjuUhjpjKRlEL6O8cvI4cl+aIoP6Juyc0T13sdijR1XR0tPlhB1kt7Wv+c5yuuOjMJJrre0l1Hp3Bjdd1n1XFe0gJh1MocEHB3u2zVnhc0yoog39hAsdpUPrcNuMwrVYnDXbf8HSB69qeXinBFIESoDqbKh/h4XeZKPBjV6OYUIH/AE6fdVU/mU5Xv8O9Aj9qmZYzWcu91JYqcAkrGtWwDYkenEhxN/BnyW+cLn4U0rWXpusywm8nNtAC+GwAp9xH+Q91EG7C1qWo8SpA1HPPYAOFwnf4AJb4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(54906003)(107886003)(6506007)(316002)(8936002)(4326008)(4743002)(71200400001)(26005)(5660300002)(186003)(110136005)(9686003)(2906002)(55016002)(7696005)(52536014)(64756008)(83380400001)(8676002)(478600001)(66476007)(66946007)(66446008)(966005)(66556008)(33656002)(76116006)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?gqEG6LBdSy07c2pU5DOcU9aYgcMXdGK1fCu2nVKZptoWJg5Jkhf9dffCes?=
 =?iso-8859-1?Q?wbd38QcUoMaInIt4Zr5jW4tRVcjq54JhPRNp/rpeIGa7vXt26Oa8cDlcYC?=
 =?iso-8859-1?Q?urwgqh/aAIVYOWnfBEUq6/P/WIWClUY1EUg12UE5ZCs+9ymMfUNk4CrNhF?=
 =?iso-8859-1?Q?fCLIPGKABj3gdANrkH4He2z7ZnfqE6HEiVpuvssGtxxb/+pzCn2yk4UYth?=
 =?iso-8859-1?Q?gg6jLjVgXUkt/tzRyokMMlFPd8bb0bOow3x68xcsKJvYdcYBCnazsl2UK6?=
 =?iso-8859-1?Q?r4wKfxZ0ur4CxxeS8afJFUpMhk5yR1O3wsyCjaCFg2A7NfnbeKbyoE2ozD?=
 =?iso-8859-1?Q?SUesHvkipZKq4E4s8MGPfMn/p2x9cGuzuD3mYdPVkm8/UIUI6KTpaFad7x?=
 =?iso-8859-1?Q?Bk916AU9bvk/vx9KdZSYYk6etnwoBcvNJ1XGKFgraSbbgoONE5R/y044m4?=
 =?iso-8859-1?Q?8Xc6Y0B5PDA8nanhzHzZGCKCrOwg0bhUWOvcNCE5wxKfQI/ZX1IS4mPgFs?=
 =?iso-8859-1?Q?gZrGpOtgybMBr0LPLczCa284U/d8NKzrpTQfWiMVOikYfp3VNffyYClOsc?=
 =?iso-8859-1?Q?gEanrD2uVOKMpcoppJzQNGpDRiwOOn4UJOsx9/zjc+ztpVPXs+p6OhwgeI?=
 =?iso-8859-1?Q?NUvUqGUeIODjL1tqXFBnEPEs4IXrVr4Sy2uoJn8yjsoPRpsmfl3cDzhGI7?=
 =?iso-8859-1?Q?0AqQ2HFguhtZGqrw4ze3pIA1MTBiEBBeVWvXUYYsFShJ5uzrOZf84WKjMV?=
 =?iso-8859-1?Q?4lvKuKhw8+UOPqiN2I0mZscsxNkfv7pJa/791KzKK0OU+XzWzbWRhlf7Ff?=
 =?iso-8859-1?Q?xKuhRLShK/GQsmBrwVKA2nXFg4fcgY2a1thHtDXzNc/zzkAsEJWMNEuC7n?=
 =?iso-8859-1?Q?sh9xjibq3Thb3d7yT0yPwUDBIOLUBSuyDYiDqO4frgVLEBonvC+q7Op+WT?=
 =?iso-8859-1?Q?HrjcbC8VTgYRrYEmhwV6N9lZ8Xa/WYzBysu6UOfBBw4hrzQu0ay3tAArOA?=
 =?iso-8859-1?Q?7Qad7IuXXugwcnhMN1/MV4UiOnQbaTvheU66gTPRZQwLl8n3IA/A5CnDuQ?=
 =?iso-8859-1?Q?O4QE1ymExNSDikrcov5t46PnkwZAWFZ+wnaolAvUvFfLh0IRvnCpH0FtkQ?=
 =?iso-8859-1?Q?W2+c9oCNfqbGX95aXzMWX5w0x0dZF3OqdZ5qe7Nwd0HeCB6sIFIkhWw0dR?=
 =?iso-8859-1?Q?HilnBLseEZfnB3Ia8eUCmUrqdQclUIIBxFEkxeRRMCU6PmX2aBHXQWrwP9?=
 =?iso-8859-1?Q?DBsN/bE4qWeky13JKen+zGrBn1+CNsCbBIBdWmjJOj+rUewV6G4tYeGS8+?=
 =?iso-8859-1?Q?bVxt1HLhm0KREPCgjDv139y4uG55SA19kcLMtJ1iQyDNPASVpxOyg9J8uH?=
 =?iso-8859-1?Q?y08SqcAf2+?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c16056-902e-4c01-ec11-08d8c80e90d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 06:40:15.7176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0rjytT6vwfMss6kJlz68n2OuL7shuGOYfkNeVdSd6eDNiQeipxBIC3Uu+wWEMFHID5KngoZen9yQUlLHr9VsSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2554
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612334421; bh=gGXdMU9PCucIawNpn47Hqwyp5U+DiBDctcwhOfcr5uE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:msip_labels:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Pg5o+m/MJ8dldHDFDdX8A8BXipeyDu+NxWZUFrmCjsnRv4P2ngVWA2SYqNB9uEbNK
         yAxLUhOy2VRofOp1F8RMq+aFsqrNf18oUGgYCLvjOMpRqib9rF2SST6M3WcM+nakzm
         iGbt6qxUt++2w7gAbh/5mBuerA40SX3GvibH6ZZ+3K19nTdNXm+GiQjivYhbKe5m0u
         RgaokjyM8hTvYcnUkiJ93g+a2d0bxD3Q0XkBHYAEHXK6Ki2YjJM098a3xFTS4YZDu2
         zQyyk+aeif9xWajDQbHKaEkVrW4VNQk+yOHaNZGeRJZkwNAWMqDyh6kNNu00lF+jsk
         bbO2/c5i0DRFg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[resent for the previous non-plain text format]
Hi KVM & AMD folks,
=A0
We are trying to enable AVIC on Windows guest and AMD host machine, on upst=
ream kernel 5.8+. From our experiments and vmexit metrics, we can see AVIC =
brings us huge benefits over decreased by >80% interrupt vmexit, and totall=
y avoid vintr and write_cr8 vmexits. But it seems for Windows guest, we hav=
e to give up the Hyper-v PV feature on the stimer (hv-stimer feature). So i=
n order to get the best of both the worlds, do we have a more optimized clo=
cksource for Windows guest which could co-exist with AVIC enabled (as now s=
timer cannot cowork AVIC) ?

Some detailed performance analysis below -
=A0
From the kvm kernel func kvm_hv_activate_synic in https://elixir.bootlin.co=
m/linux/v5.8/source/arch/x86/kvm/hyperv.c#L891, SynIC enabling would preven=
t apicv (for AMD it's AVIC), whereas SynIC is the pre-requisite of stimer. =
From the actual experiments, without hyper-v stimer, there are a lot of por=
t IO vmexits which potential bring perf down cpu-bound workloads, like geek=
bench, around 10% of single core performance regressing. As the vmexits res=
ult when we enable AVIC but having the hypervclock and rtc as clocksource, =
without stimer+synic.
=A0------------------------------------------------------------------------=
------------------------------------
Analyze events for all VMs, all VCPUs:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VM-EXIT=A0=A0=A0 Samples=A0 Samples%=
=A0=A0=A0=A0 Time%=A0=A0=A0 Min Time=A0=A0=A0 Max Time=A0=A0=A0=A0=A0=A0=A0=
=A0 Avg time
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 io=A0=A0=A0=A0 575088=
=A0=A0=A0 43.42%=A0=A0=A0=A0 1.96%=A0=A0=A0=A0=A0 0.68us=A0=A0=A0 100.62us=
=A0=A0=A0=A0=A0 7.47us ( +-=A0=A0 0.13% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msr=A0=A0=A0=A0 434530=A0=
=A0=A0 32.81%=A0=A0=A0=A0 0.29%=A0=A0=A0=A0=A0 0.41us=A0=A0=A0 350.50us=A0=
=A0=A0=A0=A0 1.45us ( +-=A0=A0 0.30% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hlt=A0=A0=A0=A0 308635=A0=
=A0=A0 23.30%=A0=A0=A0 97.75%=A0=A0=A0=A0=A0 0.43us=A0=A0 3791.74us=A0=A0=
=A0 693.91us ( +-=A0=A0 0.12% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 interrupt=A0=A0=A0=A0=A0=A0 4796=A0=A0=A0=A0=
 0.36%=A0 =A0=A0=A00.00%=A0=A0=A0=A0=A0 0.33us=A0=A0 1606.17us=A0=A0=A0=A0=
=A0 1.89us ( +-=A0 18.69% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 write_cr4=A0=A0=A0=A0=A0=A0=A0 752=A0=A0=A0=
=A0 0.06%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.53us=A0=A0=A0=A0 34.80us=A0=A0=
=A0=A0=A0 1.42us ( +-=A0=A0 3.97% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 read_cr4=A0=A0=A0=A0=A0=A0=A0 376=A0=A0=
=A0=A0 0.03%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.40us=A0=A0=A0=A0=A0 1.32us=
=A0=A0=A0=A0=A0 0.62us ( +- =A0=A01.22% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 npf=A0=A0=A0=A0=A0=A0=A0=
=A0 85=A0=A0=A0=A0 0.01%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 1.68us=A0=A0=A0=
=A0 57.95us=A0=A0=A0=A0=A0 8.33us ( +-=A0 12.54% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pause=A0=A0=A0=A0=A0=A0=A0=A0 71=
=A0=A0=A0=A0 0.01%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.36us=A0=A0=A0=A0=A0 1=
.44us=A0=A0=A0=A0=A0 0.62us ( +-=A0=A0 3.45% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpuid=A0=A0=A0=A0=A0=A0=A0=A0 50=
=A0=A0=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.33us=A0=A0=A0=A0=A0 1=
.11us=A0=A0=A0=A0=A0 0.45us ( +-=A0=A0 5.94% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hypercall=A0=A0=A0=A0=A0=A0=A0=A0 10=A0=A0=
=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.81us=A0=A0=A0=A0=A0 1.42us=
=A0=A0=A0=A0=A0 1.12us ( +-=A0=A0 5.87% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nmi=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 1=A0=A0=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.67us=A0=A0=A0=
=A0=A0 0.67us=A0=A0=A0=A0=A0 0.67us ( +-=A0=A0 0.00% )
Total Samples:1324394, Total events handled time:219105470.74us.
---------------------------------------------------------------------------=
--------------------------------
It shows dramatically high IO vmexits, and we can further see which IO port=
s Windows guest accessed.
-----------------------------------------------------
Analyze events for all VMs, all VCPUs:
=A0
=A0=A0=A0=A0=A0 IO Port Access=A0=A0=A0 Samples=A0 Samples%=A0=A0=A0=A0 Tim=
e%=A0=A0=A0 Min Time=A0=A0=A0 Max Time=A0=A0=A0=A0=A0=A0=A0=A0 Avg time
=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x70:POUT=A0=A0=A0=A0 287544=A0=A0=A0 50.00%=
=A0=A0=A0 13.10%=A0=A0=A0=A0=A0 0.40us=A0=A0=A0=A0 23.48us=A0=A0=A0=A0=A0 0=
.53us ( +-=A0=A0 0.06% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x71:PIN=A0=A0=A0=A0 226154=A0=A0=A0 39.3=
3%=A0=A0=A0=A0 7.60%=A0=A0=A0=A0=A0 0.31us=A0=A0=A0=A0 22.91us=A0=A0=A0=A0=
=A0 0.39us ( +-=A0=A0 0.08% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0x71:POUT=A0=A0=A0=A0=A0 61390=A0=A0=A0 10.6=
7%=A0=A0=A0 79.31%=A0=A0=A0=A0 12.92us=A0=A0=A0=A0 69.99us=A0=A0=A0=A0 14.9=
5us ( +-=A0=A0 0.09% )
=A0
Total Samples:575088, Total events handled time:1156983.53us.
---------------------------------------------
However 0070-0071 are rtc0 port, which means there are horrible guest RTC a=
ccess overhead. With stimer + synic on and AVIC disabled, the vmexit metric=
s look much better over IO and MSR, as below.
-----------------------------------------
Analyze events for all VMs, all VCPUs:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 VM-EXIT=A0=A0=A0 Samples=A0 Samples%=
=A0=A0=A0=A0 Time%=A0=A0=A0 Min Time=A0=A0=A0 Max Time=A0=A0=A0=A0=A0=A0=A0=
=A0 Avg time
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hlt=A0=A0=A0=A0 166815=A0=
=A0=A0 38.30%=A0=A0=A0 99.66%=A0=A0=A0=A0=A0 0.44us=A0=A0 1556.67us=A0=A0=
=A0 809.48us ( +-=A0=A0 0.11% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 interrupt=A0=A0=A0=A0 146218=A0=A0=A0 33.57%=
=A0=A0=A0=A0 0.13%=A0=A0=A0=A0=A0 0.30us=A0=A0 1362.10us=A0=A0=A0=A0=A0 1.1=
9us ( +-=A0=A0 1.50% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msr=A0=A0=A0=A0 105267=A0=
=A0=A0 24.17%=A0=A0=A0=A0 0.20%=A0=A0=A0=A0=A0 0.37us=A0=A0=A0=A0 87.47us=
=A0=A0=A0=A0=A0 2.51us ( +-=A0=A0 0.31% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0vintr=A0=A0=A0=A0=A0=A0 9285=A0=
=A0=A0=A0 2.13%=A0=A0=A0=A0 0.01%=A0=A0=A0=A0=A0 0.50us=A0=A0=A0=A0=A0 1.92=
us=A0=A0=A0=A0=A0 0.78us ( +-=A0=A0 0.16% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 write_cr8=A0=A0=A0=A0=A0=A0 7537=A0=A0=A0=A0=
 1.73%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.31us=A0=A0=A0=A0 49.14us=A0=A0=A0=
=A0=A0 0.66us ( +-=A0=A0 1.08% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpuid=A0=A0=A0=A0=A0=A0=A0 174=
=A0=A0=A0=A0 0.04%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.31us =A0=A0=A0=A0=A01=
.39us=A0=A0=A0=A0=A0 0.46us ( +-=A0=A0 3.21% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 npf=A0=A0=A0=A0=A0=A0=A0 1=
43=A0=A0=A0=A0 0.03%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 1.49us=A0=A0=A0 237.6=
6us=A0=A0=A0=A0 21.04us ( +-=A0 12.04% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 write_cr4=A0=A0=A0=A0=A0=A0=A0=A0 32=A0=A0=
=A0=A0 0.01%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.93us=A0=A0=A0=A0=A0 5.78us=
=A0=A0=A0=A0=A0 2.10us ( +-=A0 11.38% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0pause=A0=A0=A0=A0=A0=A0=A0=A0 22=
=A0=A0=A0=A0 0.01%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.45us=A0=A0=A0=A0=A0 1=
.33us=A0=A0=A0=A0=A0 0.84us ( +-=A0=A0 5.46% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 read_cr4=A0=A0=A0=A0=A0=A0=A0=A0 16=A0=A0=
=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.47us=A0=A0=A0=A0=A0 0.68us=
=A0=A0=A0=A0=A0 0.60us ( +-=A0=A0 2.19% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nmi=A0=A0=A0=A0=A0=A0=A0=
=A0 11=A0=A0=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.35us=A0=A0=A0=
=A0=A0 0.70us=A0=A0=A0=A0=A0 0.54us ( +-=A0=A0 5.06% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 write_dr7=A0=A0=A0=A0=A0=A0=A0=A0=A0 2=A0=A0=
=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.43us=A0=A0=A0=A0=A0 0.45us=
=A0=A0=A0=A0=A0 0.44us ( +-=A0=A0 2.27% )
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hypercall=A0=A0=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=
=A0=A0 0.00%=A0=A0=A0=A0 0.00%=A0=A0=A0=A0=A0 0.97us=A0=A0=A0=A0=A0 0.97us=
=A0=A0=A0=A0=A0 0.97us ( +-=A0=A0 0.00% )
Total Samples:435523, Total events handled time:135488497.29us.
---------------------------------
From the above observations, trying to see if there's a way for enabling AV=
IC while also having the most optimized clock source for windows guest.
=A0
Really appreciated and looking forward to your response.

Best Regards,
Kechen


