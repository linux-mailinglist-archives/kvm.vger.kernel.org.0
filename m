Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82953340DE
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhCJOz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:55:58 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:62305
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229790AbhCJOz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 09:55:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/RTvKORsouQRxVIM/MeKYE5EPVk8a+7jE9i11k9H8pByfaX2pKYVCWp/VxQX8PjMZiZokZx2QsZJG9a26ZVsk9Ux+IEsIRcxlqn5VPiwcp6+/KrD6X030SidG0yEiIsd/v+W8RIodFYtA14PUeIM3jpEi5tQIX4T1DKxcEZc9h/PKoynz5xXjTfxcmx/nD2CdyPCc5cwf0x1LnDBQbh8TPdAELVs850e5ub/2UzGqZDQyGncQWp646QHoHiat+xIMePxyA+UgAJn1eAxxUx0PMuPaCFkRTy/vftYpDOK11XGXDYzZB4drxVtKW1rZngQPXiqo7xxnvVUdRYhyGXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gug9eqFmEqhXWH4JHTW88VcB5aUeiiPxTR/Pk1OaP7E=;
 b=O7ezhjZtisDxc5e1Df46/WaCp9nrdem7v/6w7PijjTuJvS89alaghdD2g7ZwfGdO7tEsQQcKGH8gaGUWRvnfTNcOJ9rrriaGlBVAuhWuPZQ+InnaN9LAytnJwdoubmbgzthK254imuUJUWX+RiLmEiFkzQRamV45Lia1Vrultkz8WLfa6X7qx4PZgmlHbaiFKiftw2Dk40IyOQpxRSUqRvlDGufA/XMiVoXdKthGD1DRyyka75kf/I7lLRJ9C1IYU4fEnFBee+YDUFEk9kNFUDyXyPK4pCbD+JP3SgA1cAbu334723MZ0haogMI9KVAbs0oNN7UhsMw7tMvcHdPeyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gug9eqFmEqhXWH4JHTW88VcB5aUeiiPxTR/Pk1OaP7E=;
 b=rqVdqzATyN5hwVGCnOcbGEpHtt5RIxEdzWlOTYBwldlqZD/XbGA+0qUMXqYLee98nShYrcwqLoOpksL+r0FxJB7wM2FKKdUiKWqky9ogm35gdS5fcRhqDR/s+zrKHg6eSCf4pu1JEl0SFPwW80J50BIjrvH9ZlLnDgkXJMnWle8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB4687.namprd12.prod.outlook.com (2603:10b6:805:12::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 14:55:25 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 14:55:25 +0000
Subject: RE: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
 <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
 <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
 <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
 <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
Date:   Wed, 10 Mar 2021 08:55:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:805:66::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN6PR08CA0005.namprd08.prod.outlook.com (2603:10b6:805:66::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 14:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64ccb0e6-8c34-45ff-e078-08d8e3d489b4
X-MS-TrafficTypeDiagnostic: SN6PR12MB4687:
X-Microsoft-Antispam-PRVS: <SN6PR12MB46875811B66ECD59A74334F395919@SN6PR12MB4687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltDdEAotz/JRhhx/DKP+NGjlec3EoshSh/w7bQ5u8jF1EtYWMR85pad6vIhWdx3GUyTQBmRH/ZQNKU9wGn9SXCewcCuYGhEacOMJ/Yg/5+aRmsLE6lK1X+yxP+V6PROgbCcVQ/+NkO9AulEY87CRprL1zQ1lQ3RH1nBWUbKtlP+v8fz5FpmuDVApx9oQXcUqJW6Y1+WdRqk5grUUWNct6UYbV6ZlSivTfemlx6L1oCMhWjmMb3raxaxLV/Y2M5OuAWSKhwZ5C384dmEHJxrZXqTWKVYq0pb/X1VF3cK6bCMi3SKB40RszIZXppmiJX6cbsgyWS9JRmRzYA1J6toLLY0KB/nG/qFomV+n6DHBTUI9hL/nuvc/FMOzoDNyMaBbtwgW+A7vsCMOB7kiwxfiih47Vdh9oDC01H7rlwp7PpSYMua+OgsmszrnLFAonBS+y+idKjCNpgr1wlCpREfk9sM9bSZbZzo2f1csM+2pBRBHxSWN2INoNdY8s0n348twh/c7oAOPgSZIxMNtByAxprdQeu33i3+V5wHkaVNzoF5ZoSpvsoYbcqKo3JSrnAEBfxnVM8+FL29BRJQR0xAnHCo+Cd1OmmVpxVEFsOZSfgE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(54906003)(6486002)(83380400001)(5660300002)(31696002)(4326008)(31686004)(2616005)(110136005)(52116002)(86362001)(316002)(956004)(36756003)(16576012)(16526019)(186003)(26005)(66556008)(44832011)(66946007)(7416002)(8676002)(8936002)(478600001)(2906002)(66476007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?MsPtPVJ40hMFOhtn4IaqfBOn8h/d7/zcCfAQZsWTn+k5LMhC64G3jHEp?=
 =?Windows-1252?Q?fxu6zQLMQsmkRkfMtAIFCBmdaAxKAOL0HjSSA560a2FtXD70iCe5Lq61?=
 =?Windows-1252?Q?E54xUshybjArYohzsj57fp8yLA7QMlTlNHeWt26GXH+dV3Ayi8Y8/1bD?=
 =?Windows-1252?Q?KfVU1PFPICdlxvYQHXtmkUfAxMjA6zFWi7E5N8lhp5qG8e1xqiXVPxzu?=
 =?Windows-1252?Q?8rpEjp8Twf+7aI/GIU3ww3ONHjmTJKCk9oZtHeGmXR3eAxvAf/6XKvis?=
 =?Windows-1252?Q?tAFJgBSiNzftC+bzV5Evk7T+I49zHTumzs4L6I5toUSDOEdgHyo6XorF?=
 =?Windows-1252?Q?nfN6DrWIqRg8smeRuIlBJi7ZY1S1HT1TNxKtiDOItUxYn3n3tS2TdVRN?=
 =?Windows-1252?Q?lgxCJ44JDwQGw0Szlm7q2veT9vy+T98o7CNXf8XrWWWeq+U96rGM/cB5?=
 =?Windows-1252?Q?61DrgljfMgfLGe2cZBN+1d4Edb7/32G4/vC4Wt41Ym0yzIKpZ9g1ik+3?=
 =?Windows-1252?Q?W7XLhvjlB28fAwnveC6Hofgk3oXuSvsYyrCruOaiv/F026yAiD1Ii0mA?=
 =?Windows-1252?Q?dPCU9XdsVfnO2iRfxbJxnUVfc3jXr0t0t4S5RUXbuPs+8bZ9coks/V9w?=
 =?Windows-1252?Q?a5WA/MM6vZOOJ3bqgPWl8nXQ4zTjp+gEutyUE80YPligdFU0/7NZwUUT?=
 =?Windows-1252?Q?uYMrBOCrSZn34Sl2dPD+OIUgJWsOztpQQB5jWM0NuHhp9GvfnaXv2qXz?=
 =?Windows-1252?Q?eXWv71Qzvi2TGg9TQpQrcGcAXDgO4fe/NbOxw/VErDDAuUvER1K2yHW2?=
 =?Windows-1252?Q?+/R5BzkWWKVEAtRR9LWUDET0pdg2JqA+qKyHvXRZuY1WspDigCsoUNJb?=
 =?Windows-1252?Q?gk+FTWEw8e4uZePhFCv4TDvUHmIFPbZ5Y+uNl5prRimbjiB12xlcPavd?=
 =?Windows-1252?Q?/m1pjwUrB3C3efog9Cl86esogChLLtAl6DlTEozMEr7hedrY4UKcuneX?=
 =?Windows-1252?Q?r/BjHQy6E+u9skOC+SSnpgd6zywgpL8bKo6fl364FnYs8o6XrBOxXosO?=
 =?Windows-1252?Q?U4os/KNgg6OAm6llC8VAqJinL+E4bTb/s4aW2ZtMZmxFGF58WnjIXGIU?=
 =?Windows-1252?Q?Sww/7iIcWtn2GYZzVQThfHwDqtlcITy05iRNznXFUzSY5alQHeO0qh/P?=
 =?Windows-1252?Q?+u7sUbgu30j+w6pI5o1sv3cANPAVI1bkhfMBOr+E1Y/jxiEhDSiQ9phc?=
 =?Windows-1252?Q?YYxkQPlH+pN74WaChiqeyI8s85MCqFirFqq0J1jbMym4T+PNH+Uvqovv?=
 =?Windows-1252?Q?tEH4v/6iwnA1mfgsShVkLUh+hWu3Doz2J1kpDvlPnuIT4jQK5CHP4vuL?=
 =?Windows-1252?Q?Zh4ad7q9P3yGS9O6+g5JuvYQMSeqD7uYH18Cbxz0dJLGq7HwhCuWS+lR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ccb0e6-8c34-45ff-e078-08d8e3d489b4
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 14:55:25.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtyFfji6m40Xt9BmRR5nwHm1+uN3XFvVb5ub2rghNHPfxyaAsOeb+zhxTB2BHylZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4687
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Wednesday, March 10, 2021 3:09 AM
> To: Moger, Babu <Babu.Moger@amd.com>; Jim Mattson
> <jmattson@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; kvm list <kvm@vger.kernel.org>; Joerg Roedel
> <joro@8bytes.org>; the arch/x86 maintainers <x86@kernel.org>; LKML <linux-
> kernel@vger.kernel.org>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
> <bp@alien8.de>; H . Peter Anvin <hpa@zytor.com>; Thomas Gleixner
> <tglx@linutronix.de>; Makarand Sonare <makarandsonare@google.com>; Sean
> Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
> 
> On 10/03/21 02:04, Babu Moger wrote:
> > Debian kernel 4.10(tag 4.10~rc6-1~exp1) also works fine. It appears
> > the problem is on Debian 4.9 kernel. I am not sure how to run git
> > bisect on Debian kernel. Tried anyway. It is pointing to
> >
> > 47811c66356d875e76a6ca637a9d384779a659bb is the first bad commit
> > commit 47811c66356d875e76a6ca637a9d384779a659bb
> > Author: Ben Hutchings<benh@debian.org>
> > Date:   Mon Mar 8 01:17:32 2021 +0100
> >
> >      Prepare to release linux (4.9.258-1).
> >
> > It does not appear to be the right commit. I am out of ideas now.
> > hanks
> 
> Have you tried bisecting the upstream stable kernels (from 4.9.0 to 4.9.258)?

I couldn't reproduce the issue on any of the upstream versions. I have
tried v4.9, v4.8 and even on latest v5.11. No issues there.

Jim mentioned Debian 10 which is based of kernel version 4.19 is also
fine. Issue appears to be only affecting  Debian 9(kernel v4.9.0-14).
