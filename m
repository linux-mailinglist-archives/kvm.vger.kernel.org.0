Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888112D6364
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390017AbgLJRV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:21:58 -0500
Received: from mail-eopbgr700041.outbound.protection.outlook.com ([40.107.70.41]:27617
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728969AbgLJRVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:21:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oa2kyBCv7uJePtHdPb9kfBTVZcY4g4vNr/PBpj+nSrhZmqT88NfcP3bnjBt0Rkpu7DAhC9nNcfXoY3w+v3hwoWuWZK4WYzNIKP4Kef0kF3L95Y4cv6U7IxlH9ggjXH6IpF0bhgQKycD8LMeN1dZ1WVQsFAuPamN7Qjv/qzWAXwVpYrePyRbS4wkUKxzBaHzlGkNYSiLo59YU/vMFQju1+jjNHkHIvBLc693CXRvoSonbXLCEqeoF77ri5QWsfr0S13b76bMlGJF86ZSbiWv+/z8tWgawJ58VoPD0fNIhHtXAm+lixU7Z1Y6SCmz7rKqK+TT81NoV8W3rNHYUB7uKCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHGPc4c1J2k10KkYUxGCyA3smDVE+FfDxgrNjd/DcO8=;
 b=hHP8mCFDppwj6yNYDxhAOa/W3rG7OjKH+UzUssMVFFK5zyOxMudbfKVmimHxomaYDQygwKeON1jeEOJzDVITrnb/vVLtjS0fK2nAQcJYSj2f/unT1L6UC6OpDgfRNll7EhMNxogFBia8X/MDC2JWgfYSjxpU0yDqKpJyht0j7AWXtB9ltk2NdIS2YyDWcNrhyStFISdprw0K/8Tiq8pYcZvPqLThsC/Gr7hH9zI9Y1zpRM/sRkb/kixA/rfmhjwb6atpoDtuDqCjNFdfnocgBpePWs4BhxOuXI7E6TYAmbXTtJkzsRlH7KXG2C989EuoZgmW4yjXvmt0ZIVvmK9tEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHGPc4c1J2k10KkYUxGCyA3smDVE+FfDxgrNjd/DcO8=;
 b=UAkLpWa8n3KXUFoQqgvZMWJZ+vqBXQubNvV+mdpt4kBgxwtczorcoAS8mi63+X/4rkFSma7BiBaXauDZmjW3NxCcqVL0C+zmjzWP/58nQ+2K267IzhQZjvumrPrMitXyjklRs0gdYwLFHUzvYrqy6/likIxKibGBCdjW64GS+eY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:21:03 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:21:03 +0000
Subject: Re: [PATCH v5 00/34] SEV-ES hypervisor support
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Message-ID: <0e59a4e7-497e-cb03-4501-c114b89e2659@amd.com>
Date:   Thu, 10 Dec 2020 11:21:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:806:d0::16) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0041.namprd11.prod.outlook.com (2603:10b6:806:d0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:21:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48a8a9e2-b29a-47cf-7d29-08d89d2ff89f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1350861F76BC2273FED09703ECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4BdFsW1IgTCs2vNTKyQfw68DA7Ihps9nydxnIfzCJJxZDM7D+Bpyv0GtZgq61yI+w9CZ8akRpkuI2CDOhDbnTWdam7xfbzkK1lvcx4sObGxmmT9IQxhLmF/JWYVL0A4gE65/8isb6gIt6U41EPtmu6y+/IWh2ERL9n1QTsg9e9SrNNVLd3kmyvolYa8TwXgxrjAvHnmX2J26tacdZIxJ1tEX5zQtKpHBZCHRjTKJJez8d7xGVWvNbtmP3HgL+tX4ks5sFWK8TIzjQQMRqBfjIpGC7Sc0+D+Q6KjVu2qaelGJoWJH4KwhJEmdvAFeEpUjGwwq9EKNogmkHNC1BIZJbDYsTdIHl5Cs0xd06Z5SOIfK9PLuxMzxcSxMLEv/UFTKEB5+mcgtKo8801yDFpzzXx4ECI6KjVAHKcsNNWASQI1uTEaO0fk3rq7KGU/es6A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(4326008)(8676002)(34490700003)(6506007)(956004)(26005)(6512007)(53546011)(66946007)(36756003)(186003)(31696002)(5660300002)(66556008)(66476007)(7416002)(8936002)(16526019)(6486002)(4744005)(86362001)(31686004)(52116002)(2906002)(54906003)(508600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TS94cFJXUitWbGFJeURlNFdUdlpNVVVHcHhGb3EzeWIvNk1mdElUYVRGQjZQ?=
 =?utf-8?B?RXh0Z0pUS2Q2TDV0K3FEOVBQdERkNEhteFRDMWpvYndwNWF4L0ZyZ3p2c2R0?=
 =?utf-8?B?dExSOFBJdUxzcVdpRmJVcnRvQXYwdmxyckZlY0xqaThwWlRibU1uZ2tOUzlQ?=
 =?utf-8?B?T1pwWko0aXdJcnpPYzRDWm1OU1hpS0JLK0pVM3d2eEFNYmlCbVJDcGdiOHcv?=
 =?utf-8?B?K2JJNy9uNldzQmRmcUxGSm9kVkZSeWdhamRoZzVzM1Q3MlVzNUlQWk9GSExs?=
 =?utf-8?B?L0Z0WGY1a2RwNGRkcXM2K3pScE1nV3hBRFpMK1FxaUZXcXppTlRvMk5HV0ls?=
 =?utf-8?B?NXJCZ1lsMVlMNFJGckpKSiszMnA5b2UvS1ZLOXQzWkdNaWdIYnpqVlZNeHlu?=
 =?utf-8?B?anhOUEFnZVNkZkhram1nSjR5MDZBaURqTnBhd3U0V2tDV1VDQ05EN0dOeXJP?=
 =?utf-8?B?Nk1IelFza3RJT25KV0x5SlprWVVHNktSQTFTd2p5MVczS3pzK0tVSWMrZzZW?=
 =?utf-8?B?bi94a1FQUkxHY3JDd1BvWEE4TXBQUzhaY1lKWG1sWW1pd3Fyc08zNlNLSHZr?=
 =?utf-8?B?Y0lMejV5N0xuV0ZLQnc0QSthKy9RLzBTOFk1V0djVi9xYnNnMklxWXBXcGtn?=
 =?utf-8?B?MXNzTUNQWHdML08rc214U2hlbDhKSVhxWk1QdURiTGd3R2d2aWw4S3FTL0p4?=
 =?utf-8?B?ZTBUREQvdmlrT3NITElPZjZJeUlMb21wN01vUlh5OXZYU0UySE1VUGp5WHhp?=
 =?utf-8?B?MlpFSVFCQXZuY1kyaHhKWDB1cU53N3Ivc1JtUEk4bi8vWTJSS0diSEtOZXpS?=
 =?utf-8?B?cjJ2c2Z4WlJKbzF4Z3NyclloUHVXYW1JM1JoL0cySUMxYzRxVmZYeDBYZGxt?=
 =?utf-8?B?OXlYbDU4eVpPcEF6TURsamU5ME5yOVJ4NllXMWFHRGlWRmFHS1lTbk1mQ1Bj?=
 =?utf-8?B?Q0FpOEk1SWI1TXlUaS9qRE1QT1IyWktubm9RZi9uTEdGQ1lRM0ZCRlYrcFZ0?=
 =?utf-8?B?dzMydmRIME4wR0kwWTFVUFNsaEc0aHJsSzRoZ1Y4SU1wbVI1U0ZUak84Qlhj?=
 =?utf-8?B?Vi9VR0tFcFFxS3ZNRC8xL3orMTNYaHVwanRwYlEvT3JrSS8waUY5bllWVGZl?=
 =?utf-8?B?L29LT3ZZakJmQis3ZzNRVHg3Yy9tMHRrWVAzZmkreC9McWZjQlUrSy9aYjl6?=
 =?utf-8?B?WnBmMDlYamoveFZQelRPZzZpQkRraDVoa0FtNkliVi9saE8xeS90R1FCOEpU?=
 =?utf-8?B?a2NMUnNRRm1ZWG9YYXh3bGlSU211S2FRcXA2dEEzL21BRVZ2ZGZUZGtyVEFK?=
 =?utf-8?Q?//pL1zAu5ElciK8RrDSBO9CkqokqgykdSk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:21:03.1931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a8a9e2-b29a-47cf-7d29-08d89d2ff89f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTzLB612BB/GR8APuQOhLU52U4/HGe1MPySu4L2YC5gIIS/N0Qe4PUmcoT97rK98bB3ymyJbHApsghwkzXDvdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/10/20 11:06 AM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for running SEV-ES guests under KVM.

I cut the first send of this series short and resent it with a corrected 
email address for Sean (since he is copied on all the patches), so please 
look at the subsequent submission.

Sorry about that.

Tom

