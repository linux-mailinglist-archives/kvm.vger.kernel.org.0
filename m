Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7489E48A771
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 06:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347284AbiAKFvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 00:51:33 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38962 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231574AbiAKFvc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 00:51:32 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B3TLlu018725;
        Tue, 11 Jan 2022 05:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=YO3j0dEoF7LicnQxvUSHOlvUYubFDiNgPCUKMYWKnvM=;
 b=Nqo8kWvnB/yQSM4UEf8lOYZZWBQuRnkZVWi8d+wDSMSg6dRB2p+OQ8teh/F7InlaBlsa
 KE56R1mIAh5xvfu2ZikpMrp6jP9X4KjWD6bDqsFoGrq2CfR5kBjNiHFILjmyN2NHPOxm
 yQBU0TdgA8q+nU27UDamzC7Xo5hzxAE4E9u4rASEcdVfQQTYjBi2GEhQ6jO9D3ptMUHz
 SrIpqX7tMQUKlSuz7gNdroGkC62fLTYtThfgARz+cqOz8xeEZkEiPhVRmhOVraYXgtCQ
 SwNs6QrzKArvzjOEF7WgHruEmejVy8YkWNj6eEH6j+7XZgso6Vl8g+AXfraPcpGsTiiW Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7nhxnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:51:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20B5oQMe182760;
        Tue, 11 Jan 2022 05:51:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3df0ndk2j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 05:51:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcryjVTlFFUe8lRfmtaHrXpsBdolFG0LEhU1gypK6aj/axXykNghFf4JqUiNAr1pcn6EY7ILSulgIvAMhg+qG7xS1ENkBkyvgyHcB3l6kmXd3iv21IKXh8zylEwjB/8ROjuRr5KMNUURnHXlYX+T8ohIc3pAdQ1qDRI9OROgdWXM3AvvVuSAMgdDUvUiDFmZS5UoCgzvfbQef9W2djwWYrT+Oqj4zpPmqGXaJeX00ec9igvrTDx69sdxh/OT+WngSbYYtokvHWT2NQHnPUHNrxdITB6d+ChxWqTN9Cu3UrPsEttNfPfXB8pQ5KC65ugKBBH+5aD0IulZBJXK0GRWPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YO3j0dEoF7LicnQxvUSHOlvUYubFDiNgPCUKMYWKnvM=;
 b=YpXQFkQ47gasHLCIh2gkparmkFNBC5rsNqEBepDU1KJzC3nHkeKXValDPFSdXP4hDiMExPka3cLqIvZNiA/nsJSD2YnwGERfHg+mlWgMlpx3b0T0pIgMfHqN73nBcXnaC+w7jurChsrApeKNC3uQyqrqYsFD6QOMq3zCtUPDMGJOD1cH3maxwYxJLidSapp04joPXodS+l9wXiLpjgTecTI/8hFKOdB/pGUViQ2ektDwmrGi1Kt46nLfYBcUlflh0+GrW1YobKQuImGiBwQCSrle5HOzSzdUbYIB9BTcbpolXdji3nqpRsei9LM8AJ11NmC0FTPgkw/RlBadZ/j1qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YO3j0dEoF7LicnQxvUSHOlvUYubFDiNgPCUKMYWKnvM=;
 b=u/ZEXVKtuzCZiWd1rRwUKAFFDv5lYs5BhUFFlnzXy4Y5SWpeJGzGXEj1+qYty8wioDz1reoOmWDYZk4TStjFUpEpcxPuSpId88cpNbU/taenz1tjJLafudJTQIBB2UcHVLWDQCQfi0imhGlBhi+CXp2K0JpfTiqsDKKU73d+oD0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5668.namprd10.prod.outlook.com
 (2603:10b6:303:1a3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 05:51:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 05:51:28 +0000
Date:   Tue, 11 Jan 2022 08:51:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     guang.zeng@intel.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] kvm: x86: Add support for getting/setting expanded
 xstate buffer
Message-ID: <20220111055117.GA3117@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::25) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f45124c-cede-4341-fdae-08d9d4c668e3
X-MS-TrafficTypeDiagnostic: MW5PR10MB5668:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB56684B152FA9CE0D57B25A378E519@MW5PR10MB5668.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jJoDzn1bJHUkKBd+bdODTe5/A7hUdXrwGUoPfBb+WevxekGgxkBT2cw656HaoqTCZhsJM1zNSjaiM3MklGCZzCtyN1tVP8hBIDFnxeAigdH5tg9MAnAXwO6nGg6teZkbGwznhtRZrTLk3N9/GmkbLA+iITu+LCn0AIKDZ1dvDmcMOJhvQ60+hjJ0A2W8EZZSwuqPgClUsA1WzLkSANlwf2hV6GjQrQcewWRdJLTHFoNlpvu8sxN9IXW2EMPzPL+1s8qV4t/krcdhVU+958aGZPePpTTYdZGFMjwArUMXKAn7dE65b5xLwfJrkf6z1deJOi5sbAjwe+GyuNEqkOU3DWpNFOGs1NQ/ifHKu+gTnKL0zNJRFWbKi8e6y1ncH8wgCiUqEpy6XuTg1GuA6CqB8aL67GNpJde16daRulbc0DGaJX66lNtKcT69WM554SfiGMwk2e7j02uzzOlDP+WaE6c89Y+xui/XrJ7b5LH6cHRbrvJe1mgBHUQSp7twvY6JC3KPNPdK/6eDp6UGAeClk2YzWBNpsesZK/1fzwUO7mbxE0J+5gOtwTfb3SsKhVJQEJBlWrIsoEdb2QU4UEFqyZSyAOOTlRgkERgQkKZrZ2AP3uZVnp1XK/Lq48YUgmmvp0QyJENBuaMeW2irMaFyod1+WOE2NMWkmSuMsSacAu/awmFPNi3BHEj0DWc81GWeo9zwh+uYgLE+B5jT4c+vmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(38100700002)(6512007)(86362001)(33716001)(52116002)(66556008)(66946007)(6916009)(83380400001)(5660300002)(4326008)(6486002)(6506007)(1076003)(38350700002)(8936002)(66476007)(44832011)(186003)(316002)(6666004)(508600001)(33656002)(2906002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GMvoxS8gImmrvzEb5bAutHC93glDal279rdhQIBNNkGHgrJPe9qg1fLksqvl?=
 =?us-ascii?Q?AVNLv22vS/OP4FfJBOzDvHib3nq1Cy/elzk8d6RQ1i9h4+rTUdfcrG1LI89I?=
 =?us-ascii?Q?Cypf4Z1lC0z/fsSVBFd4c2KFDux/dToAzsCAse91VajkKEFgQCRqvOWUrE13?=
 =?us-ascii?Q?q/DJKdjJ0WWz3HUr+IFxCn8QPlUIz2vCwcCjW22s5PbF/qsKU9/2xg6bZDS+?=
 =?us-ascii?Q?qEDTGjLpUcwijfTPL7iOqbsWw8v4WB0HyW0lORBq23BQCH7vNIAVQJwZKchL?=
 =?us-ascii?Q?+JgQc9YX2NkmpKbZPVrT0aDDeg2a1gehh99ZA265pAekMMZlzRBWJ/y1rP7j?=
 =?us-ascii?Q?qWAgz0Q5iCb6De49F4G6fRt4deSh10l9+Vt5unchpMtASDItwfxy0nm/VicG?=
 =?us-ascii?Q?KoJoQRzJ6oi3SjBF7x/6La5IlTW5CVpbZzolWdJINd5oLQYUMqQGvUyZQY5Y?=
 =?us-ascii?Q?imt4pduowDvI019eKzFTKfG0uONWXkszOu/UcIeYBbvrCdN/RqRg5/Wlsoyj?=
 =?us-ascii?Q?l9lJsyL9J6rMx0sb8hYMxuLzst94ZPm39EFjLaxLO7TphLs3EQw3krDcUQcs?=
 =?us-ascii?Q?7HLLcPjCWbko2McdHUbngGZBnIYP3DJFeA7gfd3zNcjjD+PvPZfIOB5bXhEH?=
 =?us-ascii?Q?RvLOg3jdBaiIFXx7KLxALT4Fo3LlFtBMuu0oFmY9N6jWD99Q+etjtB5vdeSt?=
 =?us-ascii?Q?d7/strjvhcqrUvwsOlsWqhAD0v+nRGPoRVPC0XgMyGv2XEhEkfoFjSkOiUA8?=
 =?us-ascii?Q?w9MajfJ3JRvLCDhhw2NI7NqQF4vGTP91VuYhwlxI4vCRIrSUV/NAAepiXuqJ?=
 =?us-ascii?Q?+pBMdEZuRkL4hrtclRY8szZWqH5QfMJdsvfWN4htTSjnZvAcx4nTnqIf131j?=
 =?us-ascii?Q?ilWKHEbKRs7enNd3LoXPpLwdFgQPtOZCOimZtPAURMFfFXsHFbRh3HnWcMJP?=
 =?us-ascii?Q?j0TUJVLrv6O2DYadcsBUZnLwPsrc3oAWXI/nP+JzHHYMwqxX72xzxvknl5nt?=
 =?us-ascii?Q?gjLySfBVB2V9g3bNFPJoXLUmu1gkfhwj0jXdXjMfWo0us3ix3RxOtAuxfdC5?=
 =?us-ascii?Q?2umVvPyfCZHwpA8xkCXdpOs3LXZdIBTBexUE9b9vpyiDykUjOIlj17g2nKtz?=
 =?us-ascii?Q?MTGoJWErEGdkM3DlEjf5iPR6WvnpQ4ry2pda8s4e7UOWZ4XF6mGOOY2JO1dk?=
 =?us-ascii?Q?vlCrScmA/6Bqj5NT2D8CTtLc8XdOVat6T2MCg+6CqVlD859+HCDMTul5olTc?=
 =?us-ascii?Q?gQ2c3yVz2653FRmjhetJqVP2dR5eo72vCmhEGDal1umRYv2Q/Iny/PqCjTPx?=
 =?us-ascii?Q?b2d8F1noQzuIXAM8MNr/qysfIwUhwO0OvxPaSw4VunW4T5J/5aKLvZYguSoc?=
 =?us-ascii?Q?fU9/Rb6IWQKlQd45VIU0c0BPef6pXBTRpm3sgmIRdBKqC+Bkbh1WxxR+qIm7?=
 =?us-ascii?Q?OkFO5pLWtNEEvUsBxqR8FEqInGvsr61x4D6dmdyPmPbIRlhzhf3UPDg7GY7Y?=
 =?us-ascii?Q?XrLKh05FFoKOLy1ONgpemVzYMz3eR9QAOK0FeJik+0ybhVp8/U0ZHg/ih7p2?=
 =?us-ascii?Q?6xJC34+J68rEcsDZg9WMRwlPzUOgrjg8Lpmzc7Y3tc75EAs+4RbGXZ6xkLjg?=
 =?us-ascii?Q?T6G/fNGkxdQe1PlS2UgDOnvlxKc8dTYRkdUA1Tzi/VKY6mZw3EM0QUdYBU1P?=
 =?us-ascii?Q?faCPgqqGFT0mwEIYM5lGDK4WLMg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f45124c-cede-4341-fdae-08d9d4c668e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 05:51:28.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PK8tzXt2FfVR6qDQmsdr3+3WJDIKiW5DOLnjCjqbejAnUk9buNHj8s+kdw6P+7itugJ7EmxP0E3j/bjuhZfyckJlxK36GjNEvCC5cp0rLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5668
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=846 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110028
X-Proofpoint-GUID: YsTmt06vL_3r4iUB4g7enY7uuq_Nrxe4
X-Proofpoint-ORIG-GUID: YsTmt06vL_3r4iUB4g7enY7uuq_Nrxe4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Guang Zeng,

The patch 16786d406fe8: "kvm: x86: Add support for getting/setting
expanded xstate buffer" from Jan 5, 2022, leads to the following
Smatch static checker warning:

	arch/x86/kvm/x86.c:5411 kvm_arch_vcpu_ioctl()
	warn: is memdup() '0-s32max' large enough for 'struct kvm_xsave'

arch/x86/kvm/x86.c
    5390         case KVM_GET_XSAVE: {
    5391                 r = -EINVAL;
    5392                 if (vcpu->arch.guest_fpu.uabi_size > sizeof(struct kvm_xsave))
    5393                         break;
    5394 
    5395                 u.xsave = kzalloc(sizeof(struct kvm_xsave), GFP_KERNEL_ACCOUNT);
    5396                 r = -ENOMEM;
    5397                 if (!u.xsave)
    5398                         break;
    5399 
    5400                 kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
    5401 
    5402                 r = -EFAULT;
    5403                 if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
    5404                         break;
    5405                 r = 0;
    5406                 break;
    5407         }
    5408         case KVM_SET_XSAVE: {
    5409                 int size = vcpu->arch.guest_fpu.uabi_size;
    5410 

There is no check whether size >= sizeof(struct kvm_xsave).

--> 5411                 u.xsave = memdup_user(argp, size);
    5412                 if (IS_ERR(u.xsave)) {
    5413                         r = PTR_ERR(u.xsave);
    5414                         goto out_nofree;
    5415                 }
    5416 
    5417                 r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);

So this can read out of bounds.

    5418                 break;
    5419         }
    5420 
    5421         case KVM_GET_XSAVE2: {
    5422                 int size = vcpu->arch.guest_fpu.uabi_size;
    5423 
    5424                 u.xsave = kzalloc(size, GFP_KERNEL_ACCOUNT);
    5425                 r = -ENOMEM;
    5426                 if (!u.xsave)
    5427                         break;
    5428 
    5429                 kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
    5430 
    5431                 r = -EFAULT;
    5432                 if (copy_to_user(argp, u.xsave, size))
    5433                         break;
    5434 
    5435                 r = 0;
    5436                 break;
    5437         }
    5438 

regards,
dan carpenter
