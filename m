Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812FA6F8751
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 19:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjEERPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 13:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjEERPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 13:15:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D659F11635
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 10:15:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeKjIebYxHlc2P4+LDqZ0H8ECJNgDhnXZ3w+QvsrHocMqf37J9sa0JNlXDsRVn02vEqvZqrnbwaWCmvaUd0eGmtz2eDJRJGbPXrKDE45X3JITnlKsRNORxCr96O2aJ+vfzna/50SGfjXFDgaNfpkczKaRe8iCGImf1D7i1rOyMERYxca0vvb4ti2aRfrMCmP0zReb1ZG3/iTnR1Afr403JPa9iyznqJWbMNklr6/NKcR6y3/+bga/JXfiaagHZiAG3vP3wK4YhZk1QXi5OPT44lWGWlWsQ3efiL12i+JHnmn8rb3WA3X0EAQTp6EZaMDp4GccBcNlxi2rFlqK7yryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWJ71RRIvmdLbKRcfBkhmO7An6FiUl2yPKmC2TfH+Kw=;
 b=ZUggWd8+IV2WIUDaHUlSNAbrcRN1nonzkMo08dsXC+UqXtObAS1OKfDjp9aATRKWSiVFmQQV9pm+VcmmPRkK6i5QHfqZo8MkU9z26oMtgEaAdzNE9YuZpYWfJLQxUE8ZcoE1DktMetLbkLxP7vWWQYhN64ljj5QiapAxpTJkT+vbpsv4x3H8q3Dm45WAr6o09qaPrXMCmooGoCuR1oTzl8iatFx2MFR0NSeYw1Px9hbYSxXiJGF8mY5e9cDkPiyEldfXdjosMbbq9+9qg+dJgc+jLGpc8cy4xhI8V9Vs7mJqMWn5tdDHdQGjftaBeKBjukfklw2SM5DAo5IMDMUJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWJ71RRIvmdLbKRcfBkhmO7An6FiUl2yPKmC2TfH+Kw=;
 b=qaKjFnGZDCoxD+OjRWSzBq3HvLupFnp5BgcPep4nuDt7Yw3vhpMgWLGshA4dr87aCx3HeFEKnBF9QotbBEV+JFyuorjzFB4nA9AV1RC28xuc9qc8+4pbpT5NnhkVZ/p8WfprHrHPKysCGDqP0JhF+GovPdX73rQlGdSXTKBJQGw=
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CH3PR12MB8284.namprd12.prod.outlook.com (2603:10b6:610:12e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 17:15:13 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::216f:6f0f:4a21:5709]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::216f:6f0f:4a21:5709%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 17:15:13 +0000
From:   "Moger, Babu" <Babu.Moger@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "weijiang.yang@intel.com" <weijiang.yang@intel.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
        "paul@xen.org" <paul@xen.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "yang.zhong@intel.com" <yang.zhong@intel.com>,
        "jing2.liu@intel.com" <jing2.liu@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "bdas@redhat.com" <bdas@redhat.com>
Subject: RE: [PATCH v4 0/7] Add EPYC-Genoa model and update previous EPYC
 Models
Thread-Topic: [PATCH v4 0/7] Add EPYC-Genoa model and update previous EPYC
 Models
Thread-Index: AQHZfsqAitObOsPYq022TRPPGpPBuK9LWlUAgACSQlA=
Date:   Fri, 5 May 2023 17:15:13 +0000
Message-ID: <MW3PR12MB455346A03BA00BD2E1E69B4795729@MW3PR12MB4553.namprd12.prod.outlook.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230505083116.82505-1-pbonzini@redhat.com>
In-Reply-To: <20230505083116.82505-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-05-05T17:15:12Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=1521cee1-037c-401d-a7bb-7f313b8be8c8;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2023-05-05T17:15:12Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: abbd6e3e-6bdd-46a3-8911-de22ce2146b1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW3PR12MB4553:EE_|CH3PR12MB8284:EE_
x-ms-office365-filtering-correlation-id: 2c5d6f42-865a-4173-60af-08db4d8c4a0b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJ5Tjn8Q0Ty1mNvZfMdwI+Fm3PoZ6IbiOYRFL9QujVXyWE904Sl02HWq3qfrEi3clWXef/KM+dxLY2i19OEBiX6fQrWMiYzQKxu7dP0IesyLnhstBAzYKF9scnnlNiWggdgw0KUul+PhPZpyee6Nn6ws+tfyiCOwyerBv3GTJc7DQcdqj3J21pO+VifePiJSVkt8LD4yFfy6tiP80qOnnbtjS2G6GAJ7V7PFTlfPfRV/KsHSkT0oxDRnoydJKSjYkVWfNq19UYXmO5UiRpO/ElrhJQ6X5ZQtdnaZ8pHQgWh145vP9Xflsuh1morvNkusfW38QWiDDluHpRiGsWyy+cgrgioGWQ514Q3stdurBo9EdDP3zFfW5WUcZvhNodCYo9lNAQ8rAmFwfMupbI/IM5+nxAlpufZBgt1QqqRgf5l2KWLnEPx2c+anTeGJFP4SDzMrnuwTlTaRltQvdrJRLTW1bPz3mBATeS50Z0j7NObCMX+TsFYdqySR3ZecKESg5+YCvCaAs6vP5bv29Uu378LDlhycsSzS42pl+fe6Dmzb9/tafGm/5YMCTAwgQvavnIT7RCXyII1Uzr1ZK1kF58QLH+TuP1ix4iSIo33ZhcUr9K9zp3JA5ZLYAYhzpy/Q/HZKYvL1AWSaZ/tJH9gx6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(33656002)(86362001)(54906003)(316002)(6916009)(4326008)(76116006)(66946007)(66476007)(66446008)(64756008)(66556008)(7696005)(478600001)(55016003)(8936002)(5660300002)(52536014)(8676002)(4744005)(2906002)(15650500001)(41300700001)(7416002)(38070700005)(122000001)(38100700002)(186003)(26005)(53546011)(9686003)(6506007)(83380400001)(71200400001)(170073001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xLerc/3Pmmte8DXSkX5Nbcwoo1qgM50BRK/CmWIUa89vi0fqmbsfKf+QHJh1?=
 =?us-ascii?Q?FMWIcRDfQrvZQBs3UWi8UGz9ZumE00WUDmJ2zRKGtC55yWbX/u9/dWUy5Lvy?=
 =?us-ascii?Q?x9itz0eQ0eybAXTOKUYOJMFAXP+gfS6t01vubnXNwtPaZuqBcET55PCWq6KX?=
 =?us-ascii?Q?Oek+4H8mSm8H2CU5l+ETCOD9UR3c8NAE8Y1vzDQU18/q235f4gKF2628a8MZ?=
 =?us-ascii?Q?JEb3LV9THwXuHdLmJiPuKQ330rbQARr+6wt7sKumhoj/uMru+U917hqizEMv?=
 =?us-ascii?Q?PUD26kCzDziaCwAyZzRr5z0T1MTeGi/rP+2abAa6RemT97R0PE3GUYysiUo/?=
 =?us-ascii?Q?srdETrF1hw5Z1IRHcxhl4DgMqHZLA8PwdTB1MSj69BsQT6FHtIuAscvEqy/q?=
 =?us-ascii?Q?8hV42P3kFS6hO8ZPHsm6NRDecQv1oL/tj/zZACHhsXBtz7mgdiMcKa5x9r2P?=
 =?us-ascii?Q?3YTN81j8uy+4tiVCX7yLg62Cb/heVtTeBVNaKd6coleud3kKs02Yb2ytqiJR?=
 =?us-ascii?Q?TCRrfiIBLFcKXYrax8MDhIg513n6e5FPJV3pZwN84fCx2/4yguaog4mz9hsd?=
 =?us-ascii?Q?57qxEgmEGiLLrqrKP9b13HRWNnfATAFXOckDMrrbJcSjS6akiO6byZR923Y9?=
 =?us-ascii?Q?UATeM0NEpm6HtGdF7FpDNrur+mOiwecez3jBBix6Hxi2ehABR/EfEfzDlwMB?=
 =?us-ascii?Q?yKUL7gfd4+OZYrgYn8KSQqNhr9rG0NZnAZhgCrFcMtfyInhk3do6hWOomwSY?=
 =?us-ascii?Q?Gi1IepBHDH3fcJo5q7x/S+Z5bWGVo5+Ja/V6EFx33jVpchL2PRutnN/rKXjc?=
 =?us-ascii?Q?xs0WIaQJWMw/K0UMKjqSqNT/cEAfDaAJ9BEo8dkA4PaDygcci7IlmjI2Wkt5?=
 =?us-ascii?Q?XtUkFc/p4fciPz7AKkokJdKquMGEn0CeDWuDOb53PvgecG2QIu4lJkAQekcY?=
 =?us-ascii?Q?aZKDSkA1Phxjo0wbGMbOsU+qdJ/EJHD3H9f2bjuhNHZvABg4JSUE4J1ZZgmo?=
 =?us-ascii?Q?A7icRUi7GRmHmZ7gYFcJQLWowlPoUw1avREP2zZ/qw6o3BY9lnLdJT1sM4eR?=
 =?us-ascii?Q?mdmj9KcrRsfYff/2F4Mu+GOZcoJBWnv/tRR6alzSeiFeumRMjp3kIwUqnvht?=
 =?us-ascii?Q?YP194+mTcy4l0bwO/QuzMNs2NMnoOfxBwt8FTXonZGIhAZqV/HKAjgLSLZVC?=
 =?us-ascii?Q?d1mfcWZ1B5x2iEPQLoOC/4gNI0lGaNIstizXPQb38vF2Wv3gmcB0NnK59SMt?=
 =?us-ascii?Q?sq4nPhRjS4yUlV2ccYYgZTSr/K53bDbcsK3k0FeQJGCDbHcQm71i8KS9m8pV?=
 =?us-ascii?Q?TBTV7IKCJyfmvQezxfi34FqbLbHo4UH1JnxkJoRC6d+/HvoF/er6U0234lCl?=
 =?us-ascii?Q?dzm3nDIk7PF1mwp8qkP2+91ZgfapSHvQU2dxRtppnFfJJWsaeZm+zsXDi+rK?=
 =?us-ascii?Q?/q3cT4X9a2ngERSe9G6B1gZlpL/kmsi0fM70k+n57mF+WwDKk4lbcQU+t8Fn?=
 =?us-ascii?Q?+Wj6mwKkg/MjhfJ8LIDcfaPbDGKfW0vBhbJMkbPO9+wl2JNcpu1Efr2jXH67?=
 =?us-ascii?Q?WtfPYF2z5LdgcwJewc4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5d6f42-865a-4173-60af-08db4d8c4a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 17:15:13.5932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sjNeyGY/j7tH4mLvauoxcGYniIhtnKkV0/2R7tMipjMmRkyJxQtSZKz+ZmUuIkg1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]


> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Friday, May 5, 2023 3:31 AM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: pbonzini@redhat.com; richard.henderson@linaro.org;
> weijiang.yang@intel.com; philmd@linaro.org; dwmw@amazon.co.uk;
> paul@xen.org; joao.m.martins@oracle.com; qemu-devel@nongnu.org;
> mtosatti@redhat.com; kvm@vger.kernel.org; mst@redhat.com;
> marcel.apfelbaum@gmail.com; yang.zhong@intel.com; jing2.liu@intel.com;
> vkuznets@redhat.com; Roth, Michael <Michael.Roth@amd.com>; Huang2, Wei
> <Wei.Huang2@amd.com>; berrange@redhat.com; bdas@redhat.com
> Subject: Re: [PATCH v4 0/7] Add EPYC-Genoa model and update previous EPYC
> Models
>=20
> Queued, thanks.

Thank You.
Babu
