Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888A5480F72
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 04:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhL2Dwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 22:52:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55144 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238601AbhL2Dws (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 22:52:48 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BT2amKL015649;
        Wed, 29 Dec 2021 03:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=v/JCw9msl+kMYd3BRIjvqPOm5JXRhlzPTr8WhQVEOkk=;
 b=U/bb6B17pDxdS39+y+mollYuPHrHkBh5/r0vKuzIFxMnsKPk2ENRVJTnGsUe/o0DZ3/q
 u20cQ0boLOoVynPsxhct47LD6R72R2Wx8Y3KUt17bldtzYRpUXRBmFCw8p+BJmF01eV8
 nTBvxIP7JwgUiU4lPXBd5UP3wWcgyzecqDlS+jJNpOT0CS+xKZCDgx+2j9yyZbk28Nt1
 4DYCh0PwQpuQ1i2txsbb3kZYm0ZtvY7N+FmP9yMSkOeEwUjqfngX8ZmK13cey/Qiw1L4
 JXq63UQckTNzKcdQSJA4YEwjTraeapqgCI9DGeMPBC24skC+BMyUt4XL3qwKV0KXgRts Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d7gt2t7mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 03:52:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BT3jSvB153874;
        Wed, 29 Dec 2021 03:52:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3030.oracle.com with ESMTP id 3d5rdxabvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Dec 2021 03:52:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2u88K0gx5VhQ+skFvyupvdSd/1ZzR9iOL3o50ZMFcYPXaUiK0+35TjjO6Ng+Crjvv2g9NO8IazxsEMgrOcGqlaazmMC1NNUz8/Jm41DSGHIfL/iirsJGv5iuYp7ZbmcjwSPefWQIGg32WNxeJFmeqhix1Z31GmtsLvHApgxkbHqftXheAl3v+Hv6iF7CHJSgLjIFMr62MvCmBdvB1uGTemRMcVjX8XwYZdBlLXE8SmSECnQ1HFYvTYE0W7PivRipczUR+ulkPaSgD7ujhVFXmkk46LZYWbieH3DbxvFbjOIObJ5pJKo9lpVd4pH6Eh9+WORo84nYIPQ5w/goYScIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/JCw9msl+kMYd3BRIjvqPOm5JXRhlzPTr8WhQVEOkk=;
 b=VHNpoSkMyEmHL97vC5UDuOTsJmFzDt2/Gwc+X7/b2c0/QhIniMfFUAPYhKWjIls8DjcuwfBSeBqromAysakL7SS9K0wRAB7EBRjTFnkblYGnZuFQBtX/XehPQwLUq9LDHU+ze5A0aos5Ig1DxBJBuCTogU1UIRnfgXaUAJRvnpX4zb4kZ4qNLDhDlO4IuuvEZ2CIljoXgiJ573Th9oxBtejUOw/cEwkHlFZGneGT1OSZbCTHSEoEQ1Gy2LV10eWSJgF+JAs8qAebVMcc8/0bTBQEF7BubxRgsUXiG/XQLt5MaiBE0EAup5UUhWcZS4E1ZCLkA7t3q8s0mHNYKB+i/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/JCw9msl+kMYd3BRIjvqPOm5JXRhlzPTr8WhQVEOkk=;
 b=n5akaMcdwAIF1mKHuwYyFsfloal6t6oxhvUhgWWZ7SYPnd2JU9CWr0BU6mh5a95Msy0VzK3RDvCBe0Dbji4IWYRHZEk/Gfn6G95EW3UHYwTeH9/t5dx3wRNRpZuhaIhfe+qmpnbECtYAgRWBkmGde1QqfLVhsMfTM7LSWfV5q9g=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3000.namprd10.prod.outlook.com (2603:10b6:a03:92::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Wed, 29 Dec
 2021 03:52:41 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d0a:ae15:7255:722c]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5d0a:ae15:7255:722c%9]) with mapi id 15.20.4823.023; Wed, 29 Dec 2021
 03:52:40 +0000
Message-ID: <7eb2849e-ad6d-11c5-a37d-806a1c62bb3e@oracle.com>
Date:   Tue, 28 Dec 2021 19:52:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] hugetlbfs: Fix off-by-one error in
 hugetlb_vmdelete_list()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20211228234257.1926057-1-seanjc@google.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20211228234257.1926057-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0147.namprd04.prod.outlook.com (2603:10b6:104::25)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d75a3aa-3c73-4bbf-950f-08d9ca7ea963
X-MS-TrafficTypeDiagnostic: BYAPR10MB3000:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB30001726AF861C6540B84023E2449@BYAPR10MB3000.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwPZCCslesBWixhk8EJt8Au8oCzDxLqayH/jKp6Ukyr5UN/+nh3u8HmpXZ/w1WOIkFbaOEXg5e9GaPBnRLdwbT1gcgZdICd75vr9yuVvBKujhF9Kl+nCjQTxfoxmmlFMbcmxMR+32pmEJNdvNxFeiuQl/6N3oTgz9qvF6Xxlq1UVULO9fBpYNlPO3ia/8RMeYh9zHbSYT16mcXHZ29NhBWyPhoRBqdrPlw6eHICNpVIPxNdzS/oSH2PTPjtkZ0jOfta+c3jIxOSiOvYACSxpKBQ4Zoj7qG5d0psmhl0PiSnXE4seNUXA48+MGDPbOrdYPaBISn0bdIq2V6pQUU7MP/C/khoWwWZ4c+qJsf8zUu4HG2uOQF/B1O9FQTMgpSgbIfQ1+WPixjJWs5nUnRhTq/AJxujn5Bpcg+nz08BKSh6l+VkbK0A4NXIJ1EbnC3KV9YFzhFOCKPXkdSIy5HGRUOH/75YmBjAVPeL87dlOPl2H65/Mf3zoS0c89WF3Kh/wqrgRMZeZdzsXqfGhYA+Qn0AbC+2IxwkgFjZoBBdhihyyLut91Os45dTYaGDnptpeBmV1chf8zeVCog6y2Ov5j1hAE35i9CvxDgD9PeATT6/x1LfkNhgvJuBO9Dez6QJ0Y+dx2n9TJq3u3wDC1EVdMdwDJgWt37OWyIuYxvR6U6VN6fTlSUHBr5lvvVJJERre8g6ghSWvsrvhIQHhEvkicC/FWcldc7oNMmaWZaHrMPOJH2javNlpEuuLNyA5jKnFjYjBlbesKCi6+Tu8R9KLgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(6916009)(54906003)(6666004)(8936002)(83380400001)(316002)(31696002)(31686004)(6486002)(53546011)(4326008)(38350700002)(6512007)(26005)(508600001)(186003)(38100700002)(5660300002)(44832011)(86362001)(6506007)(66946007)(8676002)(2906002)(2616005)(52116002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFE3YkZQRTNlTVJHNk5FSVorT1lzeEs2T2Jqb2FUSktRMGtoNkI0WUlyR1VE?=
 =?utf-8?B?Q0JIT3gvd2d1L1ZmenNlOTh3blFBbmRPSkNhQUJBL0l4RmJUUFF4V3l4dGNm?=
 =?utf-8?B?TlVLK01oUStvcjcvRTZablJZMHArdHJYaURFdzRGRzIxeGhnTWdwWXdxQkhV?=
 =?utf-8?B?SlFiblFNMHpnV0JTM1dtMHMzVEMvZ2h6YnNUUDVXZ05TbkJZR1BIaGk3RmRl?=
 =?utf-8?B?QVQrZmxSM1pSRm54dlFBZ0xvYmFCc29HVFpzLzFKMkpGaUZRLzNQWFh2dS9r?=
 =?utf-8?B?dWFNa0VvUmt2cFN4ZXlMNTAvMFFnRnRtZWgydzA4aElwaWlYSFQ0V0UvZDl6?=
 =?utf-8?B?cktNRmpST2VSbjUwSUMyb21MS0VZbERFOHZLVXNDNG90bG12NVNjTDVFWW9u?=
 =?utf-8?B?bjQxaDVGaUhodEpwNzQzQVFUandxbmpRQkEwSytFTkVPRkdSa3BwWWU1cWth?=
 =?utf-8?B?TVJsRnhSbFFuVkVCYkU0cUpvUXdxeG9wT202eGt3L3RvNHBsR1dJOS90L3VZ?=
 =?utf-8?B?eG9tUUJrQ2hkTmlDaFZCM3I1S2E5azJNUlZncGJ0bjQ5dGVuZ296Q2t3MTg0?=
 =?utf-8?B?SGZpUWpyaGIwMkI5TVdOaDJoWHpKM1plVm5XcWh0dnRrSDJiWXI5RjdNZE9K?=
 =?utf-8?B?OUNtcFdVUGpOSktjZ1FSeFF3aVFrSFFXU3d2Y2p4Y2ovTTNobnZBUk50SFBQ?=
 =?utf-8?B?KzFLNnNZMEtCMnh5cnlzMktYSVRBUk1iMU5wMGxxM2NQVDBMd0VQN29ORUJB?=
 =?utf-8?B?emtRM2FBWmhDdFdWNjdnYkF5OTFwUlV5Rk4zK09aVUJlTkczbDJaNWR5RW1z?=
 =?utf-8?B?eDVTNEpYMHlrZkVvZjBCakY4a1l0aXAweUZiM1NQUUFlWjNPQlNKUEtQbi9U?=
 =?utf-8?B?U0syTSt2aEFjTmI0TlBjV2I1dlYra1pOWHJPU1FUamdnVFBwUmpKc2hvUGFU?=
 =?utf-8?B?V3dNWEVqeXpVY2x5SVVQR241MmwyaHJhV2NaY3dKZk9va3pnUzBLVXY0RDQv?=
 =?utf-8?B?M0hFNjhyWUlhSDdQSUlHRDZYRUZkQ0VlMUhFbGo2a0UxRStvQm52RjQycysy?=
 =?utf-8?B?YzhGS01OTkNsbldWcWs1OUw1ZVlzQ0xvREJlaU85Sm95SjZVR1kvRE1QMnQ0?=
 =?utf-8?B?bWpnc3NVZCtldTJtU2JRSHRnWDRtNnpTTXJLeWlQa21oWFBjNGZLMDczZmF3?=
 =?utf-8?B?ZW9FM3RNeXhOK00xN0ZaTDN1SXVWazVzVVRXRXZwQVVobnFXSWdZRERWTjds?=
 =?utf-8?B?M0lRc2ozZVhqOG9CU0FpamdtN1ZPNG9tSzY0ejZ2ZkxBdmtnUUJWcjFIV1Nr?=
 =?utf-8?B?cWdldmtWejQvTmlSU0llVkdRNm1tRVJqOXEyQVhqQU9FMUxaRGpGRXh3WDZy?=
 =?utf-8?B?VGw4OGU2Y0Y5VW9xTUZrVGNPaUVzYnpTZUcrU2tlVkZKUU5UR1gwNzNYaEVC?=
 =?utf-8?B?TElvSksyNE9neUFSekVLUnBFei90K3I2N05rd1VxY01iNU9ZcE9naVc5Wmp5?=
 =?utf-8?B?SHpFRU1zUTRYVmNGRlR3b2tmNFRYNHVqVi9aaW40MW5Oa3dnekNaYUoxZE5T?=
 =?utf-8?B?aGpoSnVsWjdWV1RSblhMckZzYWYyOTl5NW9tZk5XeXZGeTM2MU1pMks2dkh6?=
 =?utf-8?B?SUlJRlVFeFFhVUIrUWE4UXZ1UnBUTWpzbVFKR2NZcU5HRGYydVFkMmZuS1JR?=
 =?utf-8?B?TXFjaDV3bWg2NWF5WVBKd1c4T0lLWGo5bndJUU9UaVhZUmNDZmFvQUFFN3g5?=
 =?utf-8?B?WHo0a3lzc1RiaytDTER0bzhDOXFYYS8rNEJBYys5Z0FoT1B4M0pXeU5DazRK?=
 =?utf-8?B?TUdkaWVvYTdWRmt0TlZ1WlRwbDdycm54bmNlblpUK3lPRUY0UmJ0ckFDaG0v?=
 =?utf-8?B?UWJvYWdEOVhVSTNEcTlsOE96K0xQQ0RIK0VPSEgzZ0hpM0RYT1E0QkZXMG1v?=
 =?utf-8?B?eVZ1ZWRMUHV1cUxzbDFoN3hiVDIzdUtDSnhFU1NBZFY3RGwvOEhkQnQybUcx?=
 =?utf-8?B?M0VOR1dTWlVRNTJseElQV0Q1WTM5TjZOVXplZUVOK3MwU1UzT3dmMVIzR3I5?=
 =?utf-8?B?eG1BVG9mVnhEckZoU2I3eDVHVzJ0Y25PMVJpdW5rZ3Z2c0kxYTBsaTVNUGIx?=
 =?utf-8?B?ckZhYUpxM3pnb3lSOEwzVnJxejl3NVZFSFBuWHQrNS84Y1FMR1B2aThSUU9H?=
 =?utf-8?Q?iXY36LqXcABTjE0hoOn7iNw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d75a3aa-3c73-4bbf-950f-08d9ca7ea963
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:52:40.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+LbXnj5spuNGT8Yugd7xFquYgrWJZM/Zrkeu8jFDA38zIvzFQs3ND7Ctt/0PmNlqFw+/W3iokxQWJO05zH1Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3000
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10211 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290018
X-Proofpoint-GUID: kBYEkd2QyCLtZfLWaevkET26Hv3iOu2T
X-Proofpoint-ORIG-GUID: kBYEkd2QyCLtZfLWaevkET26Hv3iOu2T
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc Andrew if he wants to take it though his tree.

On 12/28/21 15:42, Sean Christopherson wrote:
> Pass "end - 1" instead of "end" when walking the interval tree in
> hugetlb_vmdelete_list() to fix an inclusive vs. exclusive bug.  The two
> callers that pass a non-zero "end" treat it as exclusive, whereas the
> interval tree iterator expects an inclusive "last".  E.g. punching a hole
> in a file that precisely matches the size of a single hugepage, with a
> vma starting right on the boundary, will result in unmap_hugepage_range()
> being called twice, with the second call having start==end.
> 
> The off-by-one error doesn't cause functional problems as
> __unmap_hugepage_range() turns into a massive nop due to short-circuiting
> its for-loop on "address < end".  But, the mmu_notifier invocations to
> invalid_range_{start,end}() are passed a bogus zero-sized range, which
> may be unexpected behavior for secondary MMUs.
> 
> The bug was exposed by commit ed922739c919 ("KVM: Use interval tree to do
> fast hva lookup in memslots"), currently queued in the KVM tree for 5.17,
> which added a WARN to detect ranges with start==end.
> 
> Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
> Fixes: 1bfad99ab425 ("hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete")
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks Sean!

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

> ---
> 
> Not sure if this should go to stable@.  It's mostly harmless, and likely
> nothing more than a minor performance blip when it's not harmless.

I am also unsure about the need to send to stable.  It is possible automation
will pick it up and make that decision for us.
-- 
Mike Kravetz
