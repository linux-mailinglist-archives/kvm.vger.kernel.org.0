Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7246887AD
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjBBTmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBBTmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:42:24 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932AE80001;
        Thu,  2 Feb 2023 11:42:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTmO1W1SRzCa8VZ9FpCj/bjinH3VyMORdd7mjsJBR+ZWPzk0XWjFCxYsxhJZP8vQNnOMkDcsR9PLZt2IDsL3lseAA3RBVw8zAY+PIxqibPrBMtCbdoF0cayk+VpQ8dfpO3DVTQNT75MOjbIfKUJnIjiFk6lcd6EdcsLS0nkLBRxcNvZiDCXQveUVaNPOVXV4pSd7CVuBd/muHLaMTsxvnuhXX8dms2wSofCVR6QdfySW5Uj4jgZ1B8EKpnIN5YOkSuQ2aiy1ZvjYWYme4OZzLKCYH+Pja03pJhEXzMw+Vgv+WZvA3LD90a7S6lLmx6e40dGeJc31ljCetyfOdwiOVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wDY11ckRentLWwrOKRbIK5YvIUUd+M8eKRH3XG20t0=;
 b=IuPy1lJ8eaVu13tjaf6qeWYicdtdy3DEM3J2VSTR3bUsQhTiGkmZSKZq3Z8RsSf8fy19bCugUrbn6smO1CbTb8GN8klNMPXJuoXIBbilHLWmjW/CuS1mLeX3IetchUv6kTAxVv1IXnuzlKGZ+VRsVTQxgXo5XhA54bmyHelG6x+V5H8CJ3jU0FQX7SobdDuf/nyW7c8Ve+FUfkRxEeNk/QIMQJRZkrJJsUUAUBPKByNafoIPqNR5IjHixjLDhOZQgfyr/n1diZZie/P4ZC8ald7d3XON8OM7uk7C/MVGv2R9p+ch2BALyooxoiqQZcM3VVyY7O38jzF6pC+b/XWKvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wDY11ckRentLWwrOKRbIK5YvIUUd+M8eKRH3XG20t0=;
 b=jPq2AP5W5pYWsB5KDtQSKD65+V532nr2y8d9QM0bPx0bEzfYe7YqDjZjjszGFcT3FEy+3E9tw6boWiUiuEZao8MIrZF3pZKJuRJiClkW80flNoGGAQq4GbGSxxyN4IdxW3RFYA10ibACF3XK68+s0MnfBT1u8VZC7e+NDzv/ZzeBGNAAPAZg4KIFcBsZP+2p/c4xJfv2TOtfMbs4wUz8ALlJHz6qNg/OwUuEA3XMKqgk+eXxwO0EQZaMvvxET9bARlwlbawCEOspN1LtI2ShTNMMRe5d+u0I/AdNESmEWWtEtgr0aWJpTIGh6Yspa0deJ42FULwdq7UsXDAlDYwc5A==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 19:42:19 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::90c6:a307:66aa:70fc%6]) with mapi id 15.20.6002.033; Thu, 2 Feb 2023
 19:42:19 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v6 2/6] KVM: x86: Move *_in_guest power management
 flags to vCPU scope
Thread-Topic: [RFC PATCH v6 2/6] KVM: x86: Move *_in_guest power management
 flags to vCPU scope
Thread-Index: AQHZLT0+B4JFfxjUlEqhaoKhQphPla670qWAgABNPSA=
Date:   Thu, 2 Feb 2023 19:42:19 +0000
Message-ID: <DM6PR12MB350039E7E3260A0FEB77A8B8CAD69@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
        <20230121020738.2973-3-kechenl@nvidia.com>
 <20230202165643.00003a3b@gmail.com>
In-Reply-To: <20230202165643.00003a3b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3500:EE_|DM6PR12MB4155:EE_
x-ms-office365-filtering-correlation-id: 49f8e02d-e0df-4cc1-461c-08db055598c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iKOzcrYzKSHBhOzjQqAzvEcTB97XiaqeGQd+uuLNKnaZvoCDrC0/NrDyRHBXbc+cqcHPk+dFu1da86vySuLoqJpmQ0bDZG7EmtgpK+ptslEsp5SXSAzJ1Ogc9uJwSXpiXAJ2MlNVy9f6t2jsdd6vXxduJkRcjYUU5f1jDTmNOg8IWpOnjNf453oDNRejQo2M9hbm5udi89EnR+va4mesfmlwZpyuJjqwYtJuQT4m99xFq7njyalQy/XW5lIYRVehbALc67qSezPyo8NIo6H0TzYzaIwlMj8cEKkDcREzmU7Htd6o6T55Q7Xo4mBrKPIHxXP4gsIFmkHRJaZ+O5HClARk+XEkiauPz+Z4F0qVSRSNvYZM+Ld/G4Ja+1cFw0EDtqRPjRxZbfjakX5ajymImzDGEw2YIgBUgiSJzFsYSzmQS4x+OREiIHKg1xr58Rlr/7wtIDw7NwkRr6XTf0tJh4nm7bhIMETrFSl9E9PB8BIth17yvyFPzqcDs2GYVLVRkKaSrGeADNIHzRYjaZeLDf8h4wNz8GDRDDR9NVxc6liHtev+NEBfdSZm2qmu7vfruqTX9JWJuqBZTb9VdqaQOEBDRdyUzeRXDbM+dpgFjXzFWRNok78Xv7bIMkwdqkInxFJbVfYIiBGHK4uhy/ncHtI20auEpQPSql4ryga7EhUd3/rmgdizogAGcsDDbqGCUvN+bCfLuwJCU/2sapshzkbSxQj+ruvRKjoADfgjqGc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(451199018)(55016003)(38070700005)(122000001)(38100700002)(66946007)(2906002)(7696005)(8676002)(41300700001)(4326008)(54906003)(316002)(110136005)(76116006)(8936002)(5660300002)(52536014)(71200400001)(86362001)(26005)(53546011)(64756008)(66476007)(9686003)(186003)(478600001)(33656002)(66556008)(6506007)(66446008)(83380400001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vo0Y1g0rj64dB75jIqVZWLZkJnMgPBrATRdLevpBVZQfMrxQCa7yosUYsA6U?=
 =?us-ascii?Q?ZsVZzmvYd+jyY7iXN5M7Do0i678GmdZsll1WlrV70Tp9zQaUfvfsSIhISqH0?=
 =?us-ascii?Q?xEQbTLbTJ7MrIOU8lCWgx4gKdUz+li2q1xi3N+mGK9/xOL13I3rjhnmMgerl?=
 =?us-ascii?Q?KfXUmlKzJTQvsCnFWFXQGNe85S1FjI+SCr/A6bpzVxAzDgCpJxnmey6PdnhT?=
 =?us-ascii?Q?SucCwKPuZFMQnnR6/YGNLqkGFN7C1Gl6e/Q5oTO+EaGInLuqDm1v0Cru/Hun?=
 =?us-ascii?Q?6NOwx4I4fxoJmrXdalScyap5F84kvV5yrcHoM9x1ZVjSTflRgl1ObRs8Zy4o?=
 =?us-ascii?Q?I8ZUAgHvnpSwm+HY8QMWoBvLDXNdoSH5nl0fI2i4QjBTgJv6yPwyjZcGQNDo?=
 =?us-ascii?Q?E//ij7ehTJ2jU389K++mUtJP8Nh2NihrtVQvKllNO07w1NhxJMzz0mXEl1Lj?=
 =?us-ascii?Q?EIom20aYJVJII4MITz8dWutA9EUXrVgdePtaAn/rPQGRNoA5TjMHDM5vB420?=
 =?us-ascii?Q?6Aj+8QdMx9XX4oe9dmYlqZY5IXq2fgkE4FiMT4sCJ1KCCSuGlPA+H4SGmXNQ?=
 =?us-ascii?Q?ufJ4EwyREptnZfuZCd1Fa7ckUtxVElFciDa/yyZeB+4SPbFLrfnmYEfLS1wX?=
 =?us-ascii?Q?P378mUChAeGQAUaXGiGfcH3V4jjkZqj36oU/APAAwzVStD7KFpCk3Mnvpty9?=
 =?us-ascii?Q?RWFeMGzBVQ70dAEZtx40OkloULaDjAE2QRtdJhpHI3h4NHxtvIFL97FkukEN?=
 =?us-ascii?Q?rlTrGw6eyQCQ06lAUIutmo5CmNdv7Hb9Rdbjshb8rE72XEuNF4nHZS1ndGO+?=
 =?us-ascii?Q?ko35TEaEKBN6bSeBPk/D2uKK/nQYExIOWZsj4ODZQHXGgN2hE0OpdpjUBdE1?=
 =?us-ascii?Q?JHd2IH7YnI4WcuV+DEBh52JvpTx25gWRtAkcaV+eTq/huzxIzjTqlvZqFO49?=
 =?us-ascii?Q?wPvlK1WbG9R66fvCe9SeyvAQNwCqPfSloPIDBHsTdY2zErBOFC7WegbahvCY?=
 =?us-ascii?Q?SfHah3NhmmPsy8o2TcBoXOkH12eez8xPg/rbm/aIJ6MMRPUgzWZHldym+Fzh?=
 =?us-ascii?Q?5uWOtZiZ+BOy7sBiUS9RJrk6XInjtkEo2dbcLiDJ+qKRBnaNWw275laPxrZH?=
 =?us-ascii?Q?3xYy1uHfcizhdASvhr8CD4OiXQMK3X3YWRws12e5KHUZi9l0AgvnKXJF+HTl?=
 =?us-ascii?Q?tpSjHagw74zr4vVhQKXCVdtCRc/K/DTJvSNT8X/if7fwiTCgwMuM88ED/WIi?=
 =?us-ascii?Q?1c1/dNa7adNiJuCPeRnJ6H5qCz0KMd5lpONrfsIhUQ71aGkgtGlwqjKgyjSV?=
 =?us-ascii?Q?gfEQzMT/N9E7H3auul3EBUF+8KoM/gM3SYXRB5LIiJNKsactFGFuYrWlG892?=
 =?us-ascii?Q?nupkcebUH1qPpiLaHnt29zAqnW2QxvKJpDxLESmBD9Wrr7LNEUYurhORwQMS?=
 =?us-ascii?Q?zz+iqEDR3ZLbNMyZ36xKOgD1T2L+tywCiEr7nHCfFwUbarUKbxDNMzlZYJ3o?=
 =?us-ascii?Q?HxoBdwMySLB8NgU5hNugESObLLkCNc9gtHgibt5FRMW/PdSKEAj34jjYGoKb?=
 =?us-ascii?Q?3IOsEptDjS3Cez/nBnXIxaxDqWwEFQvaq4IXGUVS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f8e02d-e0df-4cc1-461c-08db055598c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 19:42:19.6521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nJwRpsE0CQbU6UfZBkbu/bgJWXb97bEWeI5VlU8O/IP1HkFFbMNuH76zOuEiO9jP5zAgkOhaA55TjLgruZasDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
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
> Sent: Thursday, February 2, 2023 6:57 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; seanjc@google.com; pbonzini@redhat.com;
> chao.gao@intel.com; shaoqin.huang@intel.com; vkuznets@redhat.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v6 2/6] KVM: x86: Move *_in_guest power
> management flags to vCPU scope
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Sat, 21 Jan 2023 02:07:34 +0000
> Kechen Lu <kechenl@nvidia.com> wrote:
>=20
> > Make the runtime disabled mwait/hlt/pause/cstate exits flags vCPU
> > scope to allow finer-grained, per-vCPU control.  The VM-scoped control
> > is only allowed before vCPUs are created, thus preserving the existing
> > behavior is a simple matter of snapshotting the flags at vCPU creation.
> >
> > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  5 +++++
> >  arch/x86/kvm/cpuid.c            |  4 ++--
> >  arch/x86/kvm/lapic.c            |  7 +++----
> >  arch/x86/kvm/svm/nested.c       |  4 ++--
> >  arch/x86/kvm/svm/svm.c          | 12 ++++++------
> >  arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
> >  arch/x86/kvm/x86.c              |  6 +++++-
> >  arch/x86/kvm/x86.h              | 16 ++++++++--------
> >  8 files changed, 39 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h index 6aaae18f1854..41b998234a04
> > 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1009,6 +1009,11 @@ struct kvm_vcpu_arch {  #if
> > IS_ENABLED(CONFIG_HYPERV)
> >       hpa_t hv_root_tdp;
> >  #endif
> > +
> > +     bool mwait_in_guest;
> > +     bool hlt_in_guest;
> > +     bool pause_in_guest;
> > +     bool cstate_in_guest;
>=20
> Better add some comments here. When xxx_in_guest stays together with
> XXX_DISABLE_EXIT_XXX, it can be quite confusing. Or maybe align the
> naming like bool disable_exit_mwait <-> XXX_DISABLE_EXIT_XXX.
>=20
This *_in_guest naming aligns with what current kvm_arch has, and exists fo=
r long time, not sure if there are still needs to add comments here. Would =
like to see Sean's options on this.

BR,
Kechen
