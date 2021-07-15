Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0513C9F68
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhGON1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 09:27:21 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:43168
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232170AbhGON1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 09:27:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxdmHRalmfFE8mAV2xyh473RLAj0HpOUe5HJDSTAGwzdrYep2ehhXnne2gldRDQGpNSrEEC0eZTuANLPn1pRvdj4pt2VK48qxJWQmjFteIteJCNZ5EvQX5YGlmclnd7o1Qt5d1y8Mt/itvHjNFYabQUNavNiJy2UYT7WEdH2lI71EGMjcZT+fY4Fj3uRXYjJ+u+KDcExjkK2I48rASiaYvNEjRNUggMpZDoontVCyI60+bCxMTlRclh7/zHmeOp6ayHfdi5EB3KG6jkRWKwi2K5lWMfyIvl4yamPxvXJiyUndBCTvAjv4vzgdzPFtFbNLZRcItno/F/rXuA0Wzb1pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P3UqQeYDL/6sGQ1nFrX0zZnu+ibUQ6G2NoFBftzMos=;
 b=kxHo29UNh0ifDcg39xZzktaM0q4JTuKkJVcYOzGksmDdDUaO4RO2jzTsL4Hbacw4A3B2QX6AcSqv1z+Ew9m4pAfRnslPQpBqiTw2/oeEzADDxEmo9js1meLedqzSAyM/qx+XGEy9T1WlP0ofU2O9M/DE7TjNiau5XCOp9wpddytfTA7LzMDo6/s/60CoM8hK5rdkybQmoV9bsJ+TugtqCEmx4gD4WvlV35J5/0MIraUuaFTDxnXdVyvjfW9xdTq+Vf7WhkCwuH91kGhqmGooSmO6aBUGDb4l/pN/iyi6boOtiL37TUX4cymKXe68Ulji/1NN5M1kcsGJqirlvvNTfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P3UqQeYDL/6sGQ1nFrX0zZnu+ibUQ6G2NoFBftzMos=;
 b=sQEHjDeTY8SOLsVy+VNfwHZs3sv6l6F5C5k9MWv07WtHhLPvK7llXvh05zB5+Zgu0h9vZhfGVWl4KiKjfOXFW0HYtxXC3qKTUQ9yn/ldsDWhWkgangoVQA4/vaLa/hic63jaxwpllgRogakp/YzXNH3hMS1ZT7Gw4AHlElcMOpU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:24:27 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:24:27 +0000
Cc:     brijesh.singh@amd.com, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 3/6] i386/sev: initialize SNP context
To:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-4-brijesh.singh@amd.com>
 <34b8bda5-9b4d-c1e0-0009-1a407a48dd4a@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4de32b0f-d4f7-33a8-3678-dca68cc8bfca@amd.com>
Date:   Thu, 15 Jul 2021 08:24:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <34b8bda5-9b4d-c1e0-0009-1a407a48dd4a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:6e::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SA9PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:6e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 13:24:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5ceab62-e49a-4a4c-02b1-08d94793de73
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384C150BD304069D789C01BE5129@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XupCGoLamyncWVvYmRGOOP/cxCAp5VRilCOlsAPaC1A7Gzp+t5Tiu1pz7Td+QVNCwB3CGSk9cEJZCuSJvcKJCgfDs7ZG9VHimjBzOZZ66VPr+ETS/BNOwqXceTJuuOczvoadgf7OuPTcq+vpP5S2Mz4rG2YGyVOEO5HmdhgRgzf3SPwtsr42Oc+uYHaUETdgms2MNXhuk+1x8whthb25HFUUbBEJjEpH3Ne0ypetzt/qWjJaE8J0YqOB4uAbG3k3aLjMRGKy6KjlPvJ2xoZD6pDsbIfclTz5+zSqo0NiO0ii+Wp4wEoZmWUdystPS8WKzQsfz0t2tAoOgAQ2yDwpwbiOJrufx8F/AXcVDYvoE7R4bXY6/rXQGJSuFVG40gc7BXeDGZmLF5KwNjF0UsCuZxJVHwkwYv4rh4ml1dFUVItGa2ghjm3uwPWnRecwAw086B+j4H/qukuDFrk2PuPEG3gVL1v2o70fsETiGjyvopELlhhPvC9GtdRxLiPnavcNFzYBir4g7QBhHSHeQqJhnwz8xCOIdtozz+Viv/YSorzTyIntdEAeP1NCIQVU7dipZW8U2fe3DodNeARQ75vhsrKFALI8IjReN6fB0wdjifPW1k/Pb0q0UjzqAluHs5M4N3KDUCRbURPio3xNvsbp9cc8Ea0QWZAfT5iewBJtNtyuH/ZF448/WAXMA9DaihMjaFFpZKCKrDMcPEXFgBHLH0D+a48Te0J0oY8pPMjsI3JbEKGHYVzyJ5l9IMtgYhf8BNJP+1IZ+7+giHjGquzSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(44832011)(4744005)(7416002)(66946007)(316002)(6486002)(26005)(53546011)(8676002)(66476007)(36756003)(31686004)(66556008)(52116002)(5660300002)(186003)(956004)(38350700002)(38100700002)(2616005)(2906002)(478600001)(8936002)(86362001)(54906003)(4326008)(16576012)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek83eXg0QWdTNWp1bmdPam02ZmtCM1pjT3ZranZET2NZY1FPTXBYeHJwNDlZ?=
 =?utf-8?B?SmwyK1JEVnFWdmNna05SMkp6R0tpMU9ydnZvei9ZVXdVNFhIQ2dINWVhWUE1?=
 =?utf-8?B?bXVTWDJTcGY4azRkbHpoZ0xKVWZVWU1YdUNuOU8vcGJwcktOd3VkRVF1cWZE?=
 =?utf-8?B?dGpWSFlKSWxLdHVvejkwSFF3ZTBNZEwzaW5GVFVEMGd3SEhhTnRPNi9BOEJB?=
 =?utf-8?B?aXVrMmpFNW5HUTAwTDNyUzNOb0c4Z3B0b0pJMm9DV3Q1dlZsUml0cFFHb3lF?=
 =?utf-8?B?dWEvMlJTVEthanVNZmxMK3g4alNHc2lyR2dIdDd5Zkp3YXFIWDM0OHMyMVo4?=
 =?utf-8?B?ek5nYnlYUjBqVHd6anRSdkdzMURaZXg1ekIveTlreVVLYWdIZ3RQTC9QaUt0?=
 =?utf-8?B?L0I5YjAyUERTb1l3VnhFdzM0aDVKd1VtaWpiZWREd2QvODBRckpZSnExNFRD?=
 =?utf-8?B?TmNsNDZDK3NyR2lac3Z0bEpJZEJHdDRBRXZlOVdmUlJ2Q3R5bHVPdDdYZ2Ey?=
 =?utf-8?B?MEd5TG1UMUJIU04xVlMwZlUvTkhycktqd0JPSHhEQXZXdk9RZWM0anZldEpE?=
 =?utf-8?B?SGNDOFJzRmc3eTJXZHFEWDMxUVZwNEJKbFdIbHV2QTBHWFZubzJ0RVQxMWtV?=
 =?utf-8?B?UHFFWVYrU1ErQmppZjQ3ZlRXQllsRFRBUkd4Wk1LcVZzbWhVci84NUQ3MS9m?=
 =?utf-8?B?QXN0aHhYaVV0SnNLVzZ5bi9HTHdNVXdObGd0azNjTG5Uc010TTFiczhzWGZG?=
 =?utf-8?B?bS92Z21HUCtSRU42UVVJTTBDdnl6T0M3bWRIVmRSNnhFMUJxNDhZRVhjZ0Ri?=
 =?utf-8?B?NEoyNEE4dm9MRG9zWUY4d1UvS0FXMmtydFh2bGdXQTNuNlVHMHdNY1VYOEh1?=
 =?utf-8?B?SmNzYU5qejJsMnpwYkcyeFZ0bndQcDhleTVUM0tvYWg3UFVqYkQ3U0JwSVZj?=
 =?utf-8?B?b3A3b2lWeEE0aDBxMUVrY3cySmV6Wkd5V2VEQmNYblNmejZNNXQ0bkV3ckxu?=
 =?utf-8?B?ZEpTWElsOXpzblpCMzZJOGxxZ0dZNTNMTjQwQ2hiamFnY3FBL014RDlJSGNR?=
 =?utf-8?B?RmI0WDY3bUZtaEE2eFJ3MERBRjZjMWJDNW9uV2JENjZVYlYyTktHQ21HbnZZ?=
 =?utf-8?B?cUZOSHpVM3Y4L2l0UU1nT1MvRnQ3U1dmeS9GSm85UEY1S1ZXbVdQOGF5Ym5z?=
 =?utf-8?B?YUVjU0tPdVF1MEg5ckplaGk5VUMvQ2I0U1dvZnByWGdCU0pxcHN6RHY0dXBG?=
 =?utf-8?B?eVpNU21qQ053ejFoQUtRalZkQjBuOFJtUzkxQURjblJPeGNwckk1TGJGbEQ0?=
 =?utf-8?B?WUptY0VOd0RsRlYzbXVWeDM4RmdsaWtUbHNwY3ozL09tMkNTa0RENUMxOHNh?=
 =?utf-8?B?WlJmd3d1VnhPU2Z4bnlFRVY3dTFnaEpQRjNxaEY1RHptL0F2R0UwckVETlVk?=
 =?utf-8?B?QmRDdHJPY1lleXNjUHEzSlR3ZFhkcjdSWVdOWmREZFBxL3ZmTTdHYVptdUJw?=
 =?utf-8?B?dzZHaVh3UnMwUGRaYXBCUTlrQVlIeDZiY2M1SVpEcndoWlJMdFRzQndSVlIz?=
 =?utf-8?B?cWZJcnFHYUxyUEw1Yk9GVHh2MXViS0pRcXZOUEJ1S1p2SElRSHlHc0JDRjdj?=
 =?utf-8?B?czVXdkNuTXI1aStwRXd1QWZIcE51OU9pQUkyN1hxcTNLdENWODAvMFo1ZDRu?=
 =?utf-8?B?YlAxaTVjc0dSZDBORlZybzdsYTI2bjB4a2RIa1JpV09RaWdyZkloRW13NGpu?=
 =?utf-8?Q?mHb3eIytfzAKJENS9EtGFvX+qLRFn6cbE3IE2aw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ceab62-e49a-4a4c-02b1-08d94793de73
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:24:26.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UlLhO1nK3bdcVHVP3LZjhwMLttexO3yMWmoiycWoAqNswpV2nrh3YlFhSVtTxWaZC3i1k7uTIqnSKSF9gQX/Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/21 4:32 AM, Dov Murik wrote:
> 
> Just making sure I understand:
> 
> * sev_enabled() returns true for SEV or newer (SEV or SEV-ES or
>    SEV-SNP).
> * sev_es_enabled() returns true for SEV-ES or newer (SEV-ES or SEV-SNP).
> * sev_snp_enabled() returns true for SEV-SNP or newer (currently only
>    SEV-SNP).
> 
> Is that indeed the intention?
> 

Yes. The SEV-SNP support requires the SEV and SEV-ES to be enabled. See 
the text from the APM vol2 section 15.36.

	The SEV-SNP features enable additional protection for encrypted
	VMs designed to achieve stronger isolation from the hypervisor.
	SEV-SNP is used with the SEV and SEV-ES features described in
	Section 15.34 and Section 15.35 respectively and requires the
	enablement and use of these features.

thanks
