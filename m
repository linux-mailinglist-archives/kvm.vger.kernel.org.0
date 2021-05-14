Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E638064D
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhENJfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:35:04 -0400
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:33984
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230440AbhENJfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 05:35:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk7I6M0aCA1sxmqFSkDToNqKIJ0vHu70TKxpM82ysRnbWD9jnrtiKeta/HtRTOVGXeXaXH6druCmJ8ypF2Riwfs36sx20Xi7wVFbMVD8nkb36N+ZGqzD1EPoWmMBIuJMsl97xKoO4aFqJHCzFsbvsEdYZzg7KeDEObwnPKotA5yY8Tya94Fsc4lIYkOHe+VIN0kxRhFwsQ6oGVbB/oBuEt+Sf8CmtEZTRT7e2ch2AtrpCaz66pWIM++hXkb6r8ZBHrlxpTd49Kg04Xti/aRwiAHaUIAXz/0+AxujNVsRpHIvg6+JrfIGMk5EiJ4gFBg2sjHsw6V1/6KmyFxeQ/Az7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3fx29q9xO8wx20VnWpTIGjoj8L8f3N97575W9nALSo=;
 b=ECDt3b67/6SZanseAwTZ5N4UNd7mb6y+BOHgb963A9y1fs2biH/UwWK2RJThJDTpfGmc8rpqTPRgrVH2FFcalXfZcXXJWwavQOwBlVOMmyYZ6m+ECLF8IH6JcGGygZwTliWHoGEZ4rcyJTRovtnxW/ErduC26B5Pm8V6cU5Rz78vHYkuAJNlqIQRHZSuHfv8InluzWjNGZa0J/97JMl+uuzs/irk02vrkIRGH8MHL6kTHbyFtt84EetMcV3TCiesQHNIr/HSsCWb769Ou87fir0N5qKdywDB5atEeQA8N8rD4NnkjO+xZKORTb4qYVE/Y5n5itVYfsYvwkvMv3ozhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3fx29q9xO8wx20VnWpTIGjoj8L8f3N97575W9nALSo=;
 b=WChlRuPJQ8MHJBhyqure1BlzGEyYEupWYG68c98crF8mtERVuYu/2ewZXLDNt2XCkVwP0bhk1G1Vsx3Bo78J6Hm7UTwxm5gaXCtZHUrIxzDej7pLv/6O0KW1WFelfMQP8vLvJd1YBJDyrNQgESH4nMVZ4od74kHAMClmE2+GwOM=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2445.namprd12.prod.outlook.com (2603:10b6:802:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 14 May
 2021 09:33:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 09:33:48 +0000
Date:   Fri, 14 May 2021 09:33:42 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210514093342.GA21656@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <YJ5Bs6WLocS0vRp/@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ5Bs6WLocS0vRp/@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:806:d2::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0072.namprd11.prod.outlook.com (2603:10b6:806:d2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 09:33:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f663fa05-5af4-4583-0610-08d916bb604b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2445A844A8F300F0BD4585298E509@SN1PR12MB2445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKcnhwDles65pYcxubn1P06jBGyD49Y+mcq+kpQApY7iOZUj0tbXRkqKd++2jsom0Avs5YopKtZ4ca8lZaxWSfI0yfiuZh9bE6jTuCJf8kXY7LzrCnAJkF4UJJOEcofCVyPcEZ5N5BYVGxV8EDVQPXhliNOWDm2uYTTZurZ+XASSY/jjsPx/NS2Rd8Hz2w7KwHk6+JhfQVP5sYlsaSsvTxPZchriCiUESN7Lg7eIsrZUA/MDZe3aw3Xk+csp6Ya/UWQQJxqPR/GvVleVdiEbVM/85SR0WN6Vaxs3+3d6dxFaOt5HxpLduBjAmeL297k8wUPHmB5TMX+YF5YWrxWvzLGeElFpIPZsMsO83JzPpoH0CpX58NQffxOs/LGObXM1/7mLRxpz9wDhQZrafNr0Q5/zdD4OCzrw9bkXKdUijeVoNDg3CbKmnOZ7EqJL5ohCoiIOP+EGN5+ID8oqG5idrtG/+ty5D8bjFSXM7LLcprLnaLGxPqRkLpdUQcoNzXY1/H42kC/mbX6w31ucZfGdO/1lcfWoDdAp4B06KWO45Nrg/uvqqUl97ucc/YsmZYSNU4JsddS3c/ueI7qdPEN6oDKxb6pFDqRFCumSz4Uv+a8zPkB5BW/v/GKFRRLKU5u3FV8oNMV/+KfbRXzZrZdEIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(44832011)(478600001)(8676002)(6916009)(6496006)(52116002)(8936002)(1076003)(6666004)(26005)(956004)(316002)(4326008)(5660300002)(4744005)(33716001)(86362001)(2906002)(66476007)(66556008)(16526019)(38100700002)(186003)(66946007)(38350700002)(33656002)(9686003)(55016002)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DwCqH/WLwcg1KI3HQugn+IwZIiFTTXsEWPv1WvXEmAwUzVbnhUxDsxRGrV6V?=
 =?us-ascii?Q?JdoWHQFhsVTNSYHmYz50G7VJxfJrgilnYrRsg9U1Rp7uexUyU9y4bcZdZB1K?=
 =?us-ascii?Q?UT3o+SGbq9EstsE6TLYiVKeEUHU+RTix4v3oH4eC7GSb8nP+vqRTlHc9k8qQ?=
 =?us-ascii?Q?f/kWmTZvtyHzdA+PCquPXG8d0UOsBQGJYJD6ATBH6zYUFWU4wEfxm1oa8jIw?=
 =?us-ascii?Q?dlFZpRRkeSpld+gvq895EdUIkt+Givm8lAhofoBf2HimPXQMrV3KZdR4sd3S?=
 =?us-ascii?Q?eF/Yo57BAvAl7W88c/CAVVb3soMVvnhCObajCak/5Ahwml/2Ea4NjKAQjJk1?=
 =?us-ascii?Q?L84W2dAON6MxTEKC8hvZjZGEpJMNGL1z7JifaXz+t76bXFt5y3og52h9tc5h?=
 =?us-ascii?Q?gyQ049KOx0jBbAwYetHLPfee4H2WL5yIetEVd9V2M4Bf0Q3INkbzLutbzuly?=
 =?us-ascii?Q?TwhGpcuSK0MSNtYySc7CbG+WsR6c5RmXJizH8jDpsU4Vstvoqzo8MFbTEKnr?=
 =?us-ascii?Q?VKbmInzUEdRTrknsrcqagv2EHCmvY0/srcahOSb0sGgpF/PttDUtSB8z6i6A?=
 =?us-ascii?Q?Xnws87OU5KaKz7bEtZTCNzsehNy96dCk66npsYLPTiN4haeG/fCHxq9iZu6b?=
 =?us-ascii?Q?Bk2YEy0uLSNkL1AVdpaCLgs1ed351LC7EqrkpnF8xBE8rFj39F4izBjVXd2s?=
 =?us-ascii?Q?+aQS2U9LjJLkvxu22wX8USdGCwSLSeo0WvUAzV7NH6dqVI+aHpDAMxgmF0LS?=
 =?us-ascii?Q?5iHsXxelBMGMRwMiABTe4By6vmldq5l05tdDQjbQ6FY6alxRiiF8deQCXop5?=
 =?us-ascii?Q?0+1wn4/txzo6hYIWAm4TF48JT1UbVCiYl9h3ZBfJ8ExfrR2nZOcB63hRGyj9?=
 =?us-ascii?Q?vrk+sYk/q0mR6+EGZ1wkVD1shrFnVPGUEJgKGbthYPXh+a5AoabpnMQKQBe4?=
 =?us-ascii?Q?2HxhUanQxm8IZ7TJzABK15dUWTj+dWDKoeYGouYfGrDqqN83tpITUhsns0uq?=
 =?us-ascii?Q?w+UGTT6Q0OviI7vKklF1KpFXuo4zGkRcPZO7cSjNju6gwg+6z2bx2b2pZ4+g?=
 =?us-ascii?Q?Zepqj3PUFp32lqPcuraQ8nH15mGt1XUokXBLHgmvw6zGHGFwicsAzPa6DbOu?=
 =?us-ascii?Q?f9X4TUtCwtCwHQ5ISOHfTczyhKBzTnZvBqnNcYDk76SHLlYKFi8z8kgpdO88?=
 =?us-ascii?Q?GMxhyxSK8fwh4QBuYORsXAkJ6623DNv0xD8KNVDIcrGu++8DvTFLvxRBGkXo?=
 =?us-ascii?Q?VScfvpX3ZgI6HMdYeZrBh8zbE6L/Kh+Rd8CHZrV31cDrSZq1xezbEYxqLdoe?=
 =?us-ascii?Q?DpkAicS9U/OJxhc6CZ2l9SCM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f663fa05-5af4-4583-0610-08d916bb604b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 09:33:48.1509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4xLnIp2aDWsXmsoAd3QzkX0ULLOd0gYslAODDgrsdMajgMFND0IqoHn0tV5ezz1nGIkSUU+taa9lZE3nWBKgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2445
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 11:24:03AM +0200, Borislav Petkov wrote:
> On Fri, May 14, 2021 at 10:03:18AM +0200, Paolo Bonzini wrote:
> > Ok, so explain to me how this looks from the submitter standpoint: he reads
> > your review of his patch, he acknowledges your point with "Yes, it makes
> > sense to signal it with a WARN or so", and still is treated as shit.
> 
> How is me asking about the user experience of it all, treating him like
> shit?!
> 
> How should I have asked this so that it is not making you think I'm
> treating him like shit?
> 
> Because treating someone like shit is not in my goals.
> 

As i mentioned in my previous reply, this has to be treated as a fatal
error from the user point of view, and the kernel needs to inform the
userspace VMM to block/stop migration as response to this failure.

Thanks,
Ashish
