Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6763068B4D8
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 05:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBFEap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 23:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFEao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 23:30:44 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C111EA7;
        Sun,  5 Feb 2023 20:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTmTbLr51dNDMCxLRfArI4xZZ/1oOk13ltJwQ6AfFiWxFJCvCXAQWADAzC0C9avEijLTsQgMT5rkY0zoBCmpXtetjlUjdrsbhmRfnD2JgXDDon787lpSr1Np1ZdYNZt69xJr7wByCwI1Cq2d21EoxFq9EuuSepPPjeOS0StPrW2Nurt2KxBYUyLveFoOycJ9/QSVvNZv4eEfENW6mGeu8L0LYc3ksXGLTa/BVFh/jPtXC4RlgSJnSGAkHdtUBEK0+vLM4oWQ1PLvYJ0LWwlHgwwevtsVendcqtOprHRM1N2Fb0wdnqgHWYPLuj8oVm4QNlsZKDpLnv6vg/T+tn2jpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72GP03O+v/PHPLgC8t0miwgivnT2a/FvCoDM/NHfgB0=;
 b=RQvPqloS61zn65mUu2p2tp14353FW6U21Dristw5ZT9Yrea2RHr3I+hxyY6WQ94LOgZa6Jz9+01g1X6DC6hpbJFd8pPOZyz8UK19J+w3JPOJCV3VgzXuvdsQTKlM+SgAVA/STT1RA6MCHApv3IZA2Cj19Wj337BUr25jET04U4nRcuuW4++AN+xlhIUOmDgRKOwicfQ7jf+4IxVW/3COUOsImtVckvle9UqbK6zU7JoG/PwlWlZI8sklBlBmZVd+pigwFM8Q1LRUqk7l5cZSJCPVruF3r6evMhh329NcdqYpvuDoyFy+nENqN4hGrLF+M5OUG8e27vTPNjG5+hL70g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72GP03O+v/PHPLgC8t0miwgivnT2a/FvCoDM/NHfgB0=;
 b=RSOSGPiU/u9nrgB5s9hMrKmsgJC6xDpQtieHlZRE2/Ax7vIL9Bx1q+kcW8MhpzRtFU0Ot1AT8oTg28a6w+nboYRJ9lG/imPg4xmdTbA8+wHOsG3lyba6KI67xXG23j9tviSbG2YYapAuywaQwnu4zGpvStaUjH3kPBdGgEYhinc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BY5PR12MB3876.namprd12.prod.outlook.com (2603:10b6:a03:1a7::26)
 by IA1PR12MB6139.namprd12.prod.outlook.com (2603:10b6:208:3e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 04:30:39 +0000
Received: from BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::4ac9:c4f8:b0f:a863]) by BY5PR12MB3876.namprd12.prod.outlook.com
 ([fe80::4ac9:c4f8:b0f:a863%7]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 04:30:39 +0000
Date:   Mon, 6 Feb 2023 04:30:26 +0000
From:   Wyes Karny <wyes.karny@amd.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        Carlos Bilbao <carlos.bilbao@amd.com>
Subject: Re: [RESEND] [PATCH] Documentation: KVM: Update AMD memory
 encryption link
Message-ID: <Y+CCYqGHCL6holAT@beas>
References: <20230103143931.120939-1-wyes.karny@amd.com>
 <20230125175948.21100-1-wyes.karny@amd.com>
 <87sffnvrx2.fsf@meer.lwn.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sffnvrx2.fsf@meer.lwn.net>
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To BY5PR12MB3876.namprd12.prod.outlook.com
 (2603:10b6:a03:1a7::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB3876:EE_|IA1PR12MB6139:EE_
X-MS-Office365-Filtering-Correlation-Id: 087cf587-95e9-45ec-63e4-08db07fae614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxJG1QvBtbzi2KQ5tzv6ZzhcfMGdjli7DkCUfZ8BMi82PqQ6jhp4xyBlqJDh1lIHa79/NMn5fMK6jbn2yE21WpY55TQAlMXmBgQzz3hNzObUuwIUSBSA5qreA8FKgpAfYho1fa4f32Ye1vyg9Lb6wqK0ygycDOXEIb9AQBt8eQECxDtxb8IhbBmqSkVyZPdD4ZPknLNTJJBX/yaaJDp6PoXfZ9HS3oBkcMcSpK6wGky0s2BXu1/dh5Z1TWrtTxaGmU6qHKzCOTtdEFWqkjV+IuoT/mgLqMsC35sGckyr8U4ABK+ShGCqyoc9n5BIXFJ1t1xZX2kfChTXn+/gPOvepQ4D0sRngi+oQAz0Jq1uxEZ8T2vELYVElKmV/MBM/jqdjMnGZQ9d9nWx3GS5SwRHV2Q77m81TrrxoDoRGKF+Yjt1vqV1g0TDyqVRx27gdX64r+ouQcCHHhC3W5xmUeOOUWJd65w0UvD+egX1+mrgKu2fSTLQJ05XyCtipR8eUCTW59ouAE1Dzajh9e3QmcbJJwUaa7v3oO7Ue9ffJBtwIwHY5cvAA5hcEPkgWIok7f4QsKyh+ClFc6TqooR1X9fnS5ctIJQfgAl/wCjIl7TXidgcv7kLsiZs1jVHmUuefufg6ibUOLcfuwP1DDT1pQZfhsx+OxVXuoedd1ltYCnbTaF5eJeM8q0oHRjk77A/ueSNwTiN4tr1+cqQiKIMlemO0pEDYuPycPNuekwMrwwH7rSb8EEG+1XBh20afavU6ofxc6FogDvN6sJKpE2CgWwaRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3876.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199018)(5660300002)(44832011)(8936002)(41300700001)(83380400001)(2906002)(15650500001)(33716001)(6916009)(66556008)(316002)(66476007)(66946007)(9686003)(26005)(186003)(6512007)(8676002)(4326008)(86362001)(38100700002)(54906003)(6506007)(478600001)(966005)(6486002)(6666004)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XMH/9zzMeu9SRdErXRenxxr02GrCiYMCz926chxfC1qkRqCNEJpS6Rq9rMd4?=
 =?us-ascii?Q?/3X2rHJ1wi0u3ppL6lNhIRzRsa+vJeRrNMtFY51TMUMQCk4aGi7LIyTz/UJX?=
 =?us-ascii?Q?iF9rjrjSl6ylP2WZ7padQHMwxasBRycjmJuI00vuZ7xYox0OO4tUjF6m0Nil?=
 =?us-ascii?Q?fLwxuLzTNKbmpt+28Bwe6obSDxqppjTAL12lASX92ihYVJ7YIWpVDEpKL7v7?=
 =?us-ascii?Q?7jj+Zq5+qMhogXKhI6CIR/DayIazgGGY3wEZky0w5i0suFROAQVZEJtJrW7Q?=
 =?us-ascii?Q?Q++fW+ofVUS8IwzI49vdtWKO1G6nikWQwkLUnZLT1hge3Fq6aFufyh69vBzL?=
 =?us-ascii?Q?XZLIiYUsfDpJHp6DT0zx9uBhb0JcqtULhQB6nwDvgcc8fsVdiJgFWLSgYfu9?=
 =?us-ascii?Q?GvqNv7J7UCD58SwUxxWSqQVhe6YDLmLfBs4IxDEdeVw4/yb9INGyR4Fe83b9?=
 =?us-ascii?Q?XRT4nGfNv2e6uiWo+7238JKeRuQiOpEzRpvXMbHGiJG7upKGo6KxBuLv19KW?=
 =?us-ascii?Q?bo7W09jpSS9S3+VilxkR71mVeL8G4t5bUH7iR0dnAo4zLryrzlDNMUWzkMoT?=
 =?us-ascii?Q?Nw3Lf7U56zRWyvIHFvjZ/LSD8UYfZVYdfAFh1aDrR4QzG/8p5rFl4FGvQLag?=
 =?us-ascii?Q?sJtVUwx7q5OFzzLItqiBqmv4hNwDQBSRETWMaavfTYdu33GY/1wH0QInyWwG?=
 =?us-ascii?Q?NxWYwpzLjuYa3aA1kZ9/rN/HVtmxziUo/kWtKNOPBz+aRxc5dZCX90soI8Gw?=
 =?us-ascii?Q?C+tr125AlWHY+D1MFrDi4fqbr2RBMtWFxX7EwSfqyj8cBizSjX1usRKNRdDI?=
 =?us-ascii?Q?5Jxgcowmd1TuWeIDli651aivhTS73T4AnMeTLlklC4HAB9aylx9tL2TLsxP7?=
 =?us-ascii?Q?M28GTZqcZGfjf4KaXdch1caw1hNxQheaDJ8v/6ES8D/NlZzTTQxhkYTowsjb?=
 =?us-ascii?Q?/FnVe3dp1jBHsURD7gGXJu1Kgiuaq3DH3gffMWYW8gizYAkGwJt071NaVD3X?=
 =?us-ascii?Q?M8n2ubadOI4RybFdTYifAp4bzp7e3ja00jTOSZhNSwA8hcw19TUqT9S5Yfxf?=
 =?us-ascii?Q?jUg2+YqvwIdk7tqOtBZTMNNkdCdb5mEdzkzS2AurOIQ72OLpAhPnBFSiiufS?=
 =?us-ascii?Q?KAFKyEDRinTEU8WwBOlJY1UkPkZqDCCjj637FlWafORmOABmPB+ryBa0bPct?=
 =?us-ascii?Q?YPPXehBzt+m7ImQnnu3nHgF6cY+BwTOt3Yb0vI1JHqEq7G4ShtJRxLVI+PGb?=
 =?us-ascii?Q?3jynWoTocIt2QcUHcX1L6wzNqpv5E1TsslgMgQItmSDGhYCbGIRS0j1tCHNw?=
 =?us-ascii?Q?ZyxT1NG52YBG21ZzmvejfTtSRpNUjMMjTqBLr+82JJ/uaoire4XYcUVn83Ru?=
 =?us-ascii?Q?gPI5wBS9yFFhj7WA91RmssPzioan3XVKTrACoFvas3xkp8+2lMUaMG2RSD3N?=
 =?us-ascii?Q?JXHt3aqgPZ5LzBHJ6GNzoHPAviokxq6VB3k4bRv/sHUKFTh+M0kBQtYObqLY?=
 =?us-ascii?Q?/VBwEwwNoP4Xp1DHOXaEiO1q693lnZhZXGrJPzrcbZrJYfsdamsc5G+7S+mh?=
 =?us-ascii?Q?JAw709KfKkEV69ICWn3iKckrGpFWnpc+ulkZw38b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087cf587-95e9-45ec-63e4-08db07fae614
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3876.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 04:30:38.9808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hO3iFc5NLXyoARJDqWr3Oqm535LAhZiE1uT+hQYenpnQBigh6TOQEEnnQ7X5R+QmbAIGNJikXhfjFAB0rzHtmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6139
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02 Feb 11:33, Jonathan Corbet wrote:
> Wyes Karny <wyes.karny@amd.com> writes:
> 
> > Update AMD memory encryption white-paper document link.
> > Previous link is not available. Update new available link.
> >
> > Signed-off-by: Wyes Karny <wyes.karny@amd.com>
> > Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>
> > ---
> >  Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > index 935aaeb97fe6..487b6328b3e7 100644
> > --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > @@ -440,7 +440,7 @@ References
> >  
> >  See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
> >  
> > -.. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> > +.. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> >  .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
> >  .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
> >  .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
> > -- 
> 
> Applied, thanks.

Thank you!

-Wyes
> 
> jon
