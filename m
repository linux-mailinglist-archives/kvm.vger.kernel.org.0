Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC85E6F60
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiIVWIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiIVWH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:07:57 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021025.outbound.protection.outlook.com [52.101.62.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91C811264F;
        Thu, 22 Sep 2022 15:07:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/GF8IZAKUPYwYRefdBo/auUYLQX/eob0mhrub9hywB0w4Uok8673t3LXn//EDZyA9UQQT3vmG+BcnwVgy2npdMTJkPmbIgv3j0mrLeV+An84uAIzfZFRSDgANnF+MlBzdYSKkNnhUoFOWkVkPiD56dzOfLIPvUU5H8TJFQmdEuxMqbio3DOn9KIEhN9WTa4XcoHbUjBqibocZ1mBgYC62VLp6Ya0AZ2wNi2ncmakMesSoWmFSHJrMhejV4oYa9mQgII/F5Cv189bYbjF994+b5daN518/oe4jrLjXXwLr3iZf96sthkYZ2e393BIiGjT1CW9LT9a9nS9B6KzPH+rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTg0cm5Zm2kMHXsZJnVKOiY0MnVTibLuQyV203W2y7E=;
 b=Ne+vZpCF72bOTuXUaZjL3i083q97Ccpwl0y2wl+eWNahCIpIQ2/h0vdI98+tNDLt6Gowlf8uMsXoHG4YwexvZ7GT9FBFFfePuXrdg3uNgLLL8EsBQM2YbC6ztJ0F1JznzUBNI0j/29nOVd3+Ikx1CflXEz+3nOAqc2yP70Y6n5bw4X2ULhit2HGmP/akE/fmgB08duR+ofEN1RWleQNUQbcoZCtolWQP/zAu5yyf5XCOrR0Sw9X8WZBFIHzA7Ss5ljlftkxhCb6ZggpvJJTXwAeoKQYoPDZciMjo6yQsaB7ku+RWoa0HSsUEFD79UyUGUoHvxBeVpY6yVg351E6goQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTg0cm5Zm2kMHXsZJnVKOiY0MnVTibLuQyV203W2y7E=;
 b=JrZoK68yHG0BEKa7YkI8/9S5Th0tNLx6+OF64/Um96+LSPbNPPKym9V75iw72xw9dBM8gdUJQ0EaME4IjLbRkzCi6Z1RDfXCFqfT8vhE25maR7lUP1n9j1mMk0zQJYia3n+gyPqWRa21EkzN7LDXIWS7mwV8raGzApZuDcU4jdc=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ0PR21MB1952.namprd21.prod.outlook.com (2603:10b6:a03:296::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.9; Thu, 22 Sep
 2022 22:07:53 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e%4]) with mapi id 15.20.5676.007; Thu, 22 Sep 2022
 22:07:53 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/6] x86/hyperv: Add HV_INVARIANT_TSC_EXPOSED define
Thread-Topic: [PATCH v4 1/6] x86/hyperv: Add HV_INVARIANT_TSC_EXPOSED define
Thread-Index: AQHYzpDKJa06rsbw7UK7JOfTvccOoK3sANvA
Date:   Thu, 22 Sep 2022 22:07:53 +0000
Message-ID: <BYAPR21MB16883BE5057ECC1BB99B4170D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-2-vkuznets@redhat.com>
In-Reply-To: <20220922143655.3721218-2-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=07d209c6-37fa-4274-9c6b-05786e3535c8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-22T22:02:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ0PR21MB1952:EE_
x-ms-office365-filtering-correlation-id: 4ce9463a-df28-453a-9b59-08da9ce6e5b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZysxVmx+ErDYmsPii+OgExxBfXrXAslJdJoyTm8yUyT1En0nfWyMqNMKhG1YTBGuEOzIEZwXgaQ6WXnBWnZil8GwWk3iCXLRD/CDvp3b/Gk5yLw1d0eUDh3+wqwrzgeBtiP2FSRS8sSGBfSgPkIziMN60sULtA+sTltp21WHdeT5PVR4Zh8/23hoK86BBd5wML2kZ2oAHl9NqynJRWVV0IhEBPs50bGRn26BXYz3mXAfsCxU55GZD1g2VLUMvfGYtOgfOOv7WQynzI59kV+GL1qPRgH0QY+lthfF8ydgWEhWnSGL8M2rCtuz4SYOoDbGDLlBKgmIKHVeQvqqJQO7VS9Z8hRK9YW+MFUwjU0/Q/pJeJ4v81RnwQFYZiqdoeDI61wW10o6pzCs5FegOWYwDO8mNdCMUSuZKsgFb7fUQC6ld06mu1UnftQmIRXrM9QX9WJv+bLtWj3kgWLt47qfTzvcNv77Dl6HPe76qVV74AFakiWYGooRLz8RfOWTMrEBIfgde/Ek/18PqtGpdW238XE3THy/4s1IUh9Uea/4UNxa4LTmddFOtMIbPM4HwU6cvZhCPWOdvimvfkqEwf9tRqjyvuB+uLoYkclbJYxtQr5eHQ9DWN5L3PoIhWeH+Wo9vFUbMlemWdtO0nGmxrWKqV4PK06vE2qQPLo6QxJi0Wq2XlEqvyXSJQLehDPkMAT6kdWzXMLAQHYOGiRW5+ul1oieNUE+fwciT8l6R6G4SGRsV8SnzeXSkeiD9YlbfwBcYRc6zdz/rpc1bFCO7vLB7nGbidvzH6gSRaWFHDX/sPoyJgPc+GtJQV1AOCg8iQsl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199015)(26005)(316002)(9686003)(33656002)(478600001)(6506007)(10290500003)(54906003)(110136005)(71200400001)(122000001)(38100700002)(7696005)(38070700005)(82950400001)(82960400001)(83380400001)(186003)(55016003)(76116006)(86362001)(8990500004)(2906002)(4326008)(66446008)(8936002)(5660300002)(52536014)(8676002)(64756008)(41300700001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3RaJod+28rqaozwpTXnLUe/VmiKuPTNzQLmwCny4BbktDKsJS+Wd+Q/7Jt63?=
 =?us-ascii?Q?e12dNv8/LMiQ2XMo1zd4xm2Mu8hpCVIn+/jsDoCUdPKvZ3Qb+pzDzQBdqLe1?=
 =?us-ascii?Q?1XL+hqLhd+ZD0OOhK8imkNX0Tm6nYqwEX+ZX0Nr+aDyeRWqpEaGGeCSZvXmd?=
 =?us-ascii?Q?jDYYLn4IKbAVPwXMvHXhauJrNIk2KZ3ox/i6hKKuOyHWym4sj+SYlC6NDHse?=
 =?us-ascii?Q?XVO2JAd6Tqnq2Im7cwjUa9OZSjYl/1VF7oUk7B85pNp2J5YhVIXJ+H00iMIH?=
 =?us-ascii?Q?hcpBtgxP3Qv421ajcHz4+VXK2J45HOSB0z+djKP/R5yi6rG7dQTBx6k5egOw?=
 =?us-ascii?Q?QtrPPt1u0LyWCbcZvPvLsJbKLMKvdiFPmFmATNcBSniFQhw7TJPGtH+0jy2b?=
 =?us-ascii?Q?KXHN+Ec+2V/vgdq3x36Q3rqGWN1xZlnksdCJmXzQ6h6mXacH7O2dGymE8D71?=
 =?us-ascii?Q?rhrQneTeRtW+2FcTKlfqrC+U9LOH7NhMUqtuI7l85h48BwGn3wSlUhkmlqRt?=
 =?us-ascii?Q?ik+t/V59Ja86kiUNpOp4hQv8qdQirs/MSC4AcVkWkmc2HL2TlLQpOqRMs+4e?=
 =?us-ascii?Q?1aw4XVAuZD9FT9fqqts4WCWZwZnDv6tvX5Xa+H7e8D9WEhKbu1EXmXTX/Ae+?=
 =?us-ascii?Q?ZEYaRSSYgM7bBTHZqLCcZzh/LrQISZwZPXaPVxw3i6rOw6PZ1Q4ZiQIVMISH?=
 =?us-ascii?Q?UulmfHExIPXHMvNlMVDl2Z3eznqYO0237+XzNAhtoHPLyKeVHJ0tXKL/q28b?=
 =?us-ascii?Q?izwV92xwhemIwA+Rdx7cbUMM5JvU8kq8vXOElDB98TpkhG0g4kKcAlOskSET?=
 =?us-ascii?Q?cefZXZSFZ6lKqoeOIhuMcDnE+b+ujZkSIAO/p19hqa6+xMhKgbxh+qil5CgA?=
 =?us-ascii?Q?svdYkoC+cBvpMpQ8Jp3dVKZ8WE0AXeE+Rt5fZVW0rhxl1DCJUuVwEx1rCpnd?=
 =?us-ascii?Q?8uvRlvZPlzCNXRxm3QXRUexF3ORVGKM4scMuTcagonXx9ArxyvBpNu384/Jz?=
 =?us-ascii?Q?FLZzgM8K4/SVc4yxOGYMCfrVlvteEBN4PpSuuXDQKpnE4sGO2F8TQ0qrJmtg?=
 =?us-ascii?Q?ncsEVQ6za+NzaZcdh46+Ere+xPgCHLJPVEut+FxiuP6cSzTbebTM3OvnBZ0T?=
 =?us-ascii?Q?i/XGx8HSWXmDTAm0oU4WOH2vFmGiw0H3Mtz8Mjvb6/j0tLgXjj2rXSW06zo5?=
 =?us-ascii?Q?Q9vSTGxizxsmFFiExjsRc6YP9q3x8A3PNjj43EaFDqePtpPG7VXFDTQz6vMD?=
 =?us-ascii?Q?iRLTC9M4icGlpFrRAZT7MGZneiJUs50P8uzyXp+u6GWYl65JAhos3fkxkoQD?=
 =?us-ascii?Q?Kmd5AewC3cnRlZ2aMo3bVaGVZ/fQJQCUuHoTH4LoAzLWCT/uc6h7cvWc+OqD?=
 =?us-ascii?Q?FmebVpDpZflp8Vkr2fhhMNs6f/Zhc1bRzsBns6DzzACFOEVL6KfAyzoxDVfT?=
 =?us-ascii?Q?Brh9DwzKLv6iRNG8mI1Ze53Ny0hHCxyI1A50nJggrcgq6BvE2UvrPIw35osl?=
 =?us-ascii?Q?YAS/GLCIKVnkbGDb22THUgxhpQj92h/e/fghzcOoBFUcAddB6T9FDo6AoDUO?=
 =?us-ascii?Q?pnRRke8Rlji/uMNK0LIUloG7uBZn2/OsEVOX1h58usWXiNaeLwnMUcqEcghD?=
 =?us-ascii?Q?gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce9463a-df28-453a-9b59-08da9ce6e5b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 22:07:53.5951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wND9PbNDh3O0nEEaRLmKKj37LSiVg7obuWVKmE5YDcqYZYB86F/3E8T8eQU/Riq1SYwdxnBoqrBgGByifYbKa1Tk+rLaIZahh/84VuMqepM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1952
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com> Sent: Thursday, September 22, =
2022 7:37 AM
>=20
> Avoid open coding BIT(0) of HV_X64_MSR_TSC_INVARIANT_CONTROL by adding
> a dedicated define. While there's only one user at this moment, the
> upcoming KVM implementation of Hyper-V Invariant TSC feature will need
> to use it as well.
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 3 +++
>  arch/x86/kernel/cpu/mshyperv.c     | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 3089ec352743..4849f879948d 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -253,6 +253,9 @@ enum hv_isolation_type {
>  /* TSC invariant control */
>  #define HV_X64_MSR_TSC_INVARIANT_CONTROL	0x40000118
>=20
> +/* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
> +#define HV_INVARIANT_TSC_EXPOSED		BIT_ULL(0)

Nit:  This name sounds like a value that is read from some register,
to find out if an Invariant TSC is exposed.  But it's actually a value that
is written to make something happen.  So my brain wants to name it
something more like HV_EXPOSE_INVARIANT_TSC.   Not a big
enough issue to respin for, but if you do respin then maybe change
it.

> +
>  /* Register name aliases for temporary compatibility */
>  #define HV_X64_MSR_STIMER0_COUNT	HV_REGISTER_STIMER0_COUNT
>  #define HV_X64_MSR_STIMER0_CONFIG	HV_REGISTER_STIMER0_CONFIG
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 831613959a92..3716c358da98 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -388,7 +388,7 @@ static void __init ms_hyperv_init_platform(void)
>  		 * setting of this MSR bit should happen before init_intel()
>  		 * is called.
>  		 */
> -		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x1);
> +		wrmsrl(HV_X64_MSR_TSC_INVARIANT_CONTROL, HV_INVARIANT_TSC_EXPOSED);
>  		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  	}
>=20
> --
> 2.37.3

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
