Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1631449FC6
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhKIAn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:43:59 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59262 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234870AbhKIAn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:43:58 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9019cs010247;
        Tue, 9 Nov 2021 00:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yQG1jFZBf9DHnQhb+UdjPPrOW0e8M+axPQBeKeynV6Y=;
 b=a5qovwH/m8HR5P/xTkwV/gTr1oe7h3an3Dtykfy7TnLFaFclyzw0cX3GgmK5MSfDqOl0
 /WpL2nq6f286OC0MO1McCyVLm7CPUw/v/yhI0xuvzfWsRJJoXn+M/3HWJcOqmGDMG3mB
 gFnstcGy3cKJO+n4j1tdgWzC6X/gAzvPoDTSCPHO1N5pUEnA6V1siHrIHokkP8xndTpE
 Q+m9lhI7ZT+rv+fY0XDHarmTCSRFremDpx0EiBqzDYeZx+SHZK2EhvmMAQ6LOAoulpVs
 ruaNpYYvyR3Gfl4B4CcBKV10Sn+W6LIKCjxqRnpLFhEQWa28LTCCeCLENv6GGVHIJaUM kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnfjr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90abOW054187;
        Tue, 9 Nov 2021 00:40:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3c63fs5fgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAWhHdiacZiQtf3z4R/hFYdGiOuM23a4o+NTWUjjG8TDRjLQsK5EbP1beA4VM8T4RF2WmmyLmI+SakyAKrOdIPlZ0GM1VtkvR+tIRQV/JczUXIow/L1fOJgoXy/TYK2RsAaJ/ZHKdEC9vudldAP9ObeFWEhRXdzW+3lzEsYlL4ET634wlCTVHh+ht1U+BBztSzDHXc85G5kyOYCbkXZ4uDcyT/E0CSdkxPJRl2JSYuwfM8xBMRLTXfT9Fxi5dCLflSTjyQCeNxQcX57GtD3lTLYLK4uWUYBDLQ95AMLYlsY0ZC2aUc8cQCj01tWIxfgYdITumPwX66NUqLn8zcwjxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQG1jFZBf9DHnQhb+UdjPPrOW0e8M+axPQBeKeynV6Y=;
 b=QPKMi5MrjSxGa+USQ9D1oTnGX7azsH90x7AZyWJZWwQENnD+N8Ab9M4oH9i6SeYJkLflpIGgzynCH9c72+5n9Qlf+T0rSK7/JavbquG5vjQnwXmFPxFMbjW63/pmddr20769mKqcPESCDdb/FMtdCh2uikVUMWra3uWTM9s7Lc5zY99tEyEwhDL7OZWH2nCpn6cbeJhIav5esJ7O4meByCwXtYPUHrKyA+ezEjPFepjUr6vNPmScoa7U9v0vZ7sbjM4sbtKqTMS7Jmd2p6C/XYtmJEN9Xn8a7k21YtgpmJ0JGIkW5/2ucKFB2TQ+ADbMrCpaCgfVf+oKRbb5d/mFNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQG1jFZBf9DHnQhb+UdjPPrOW0e8M+axPQBeKeynV6Y=;
 b=a0LQH2uLJMDidZq3lVM7/kNojLFVg+rbPKdP/mpJ1cvCrBlbhBbWoAfTDDENsu41RRCUbg+103qdR0kqQHsfYF4gIRdKuqEP+x2/EYYYIsN7SKSxo/LRbpa46kaZJcZwJHXRmp1ih4MI4elZcM4v511LMoWBusnGHjtfSyyTFVo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:40:37 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:40:37 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 12/30] KVM: x86: Use "new" memslot instead of
 userspace memory region
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-13-seanjc@google.com>
Message-ID: <14c14a1d-6ddb-e2b4-c71d-808af552bb30@oracle.com>
Date:   Tue, 9 Nov 2021 01:40:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::34) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM5PR1001CA0057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 00:40:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65934d91-c766-48a8-d3e7-08d9a3198c04
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB527303D8AC43A6E1E80F0BBFFF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7siUppp8U9PIsHAOztRhDHKTLFz0aU0cAV7cHqpkJmrALq4JtRhniH73l/Dz29MAP4ed8qYvisJbrkxMxrozJKij5mXg+JgiPhRcrpiveAzTY9XtC+qoJ7GEcBpvN2hawC1kKTsqaU/Pw9nD701Otn3SfXicbTnFBYvE23zhO2rqqoPXVRbZwACmu+V9OJdzOZoDpEUyMpCvdtMcZurExL9UaBpcqs8RrrnQWeHUzNO0WDg0SZfPZR+gP2uTssY64Hor437vVirm9wUwiC2Nx44kNN1hhMnJqjEnDMQIeBgzeWglpB9EhP8+DdcourKcd7q+A1Vk/6ZNo9RnxYBeBH/eRD7MptD0gUyH6Kb6QS/xM87RyBe0AqZfnyFXTwTjlqGgFHvc4Wr5FiGoEWn6sJTxfhlJcANUGqs1fEqLPB9JnLEA3PvzYXfkZCnj5rNXc8Hlhq4CBpKebxbyR+lECAAVaYUdtw9DDzrSUCbpixU+HhxldmUBteQUoRR84ZbI361gqBEVEokgb/UBAp6/DSikCXJ/4BwIjSHWhvQ6Torb9sdJIgnGNp05MhfGWAKR0rcrk7XmZaWG40ed8N+WAhVs0B/iscV5ElssNg/2VrNnXf+LveNrkSP4a7SzoUUXQEvEM9VSliZBnJEsTrhTImvaBOc/S3yeWTrXA2ckpQjJmYF7ItYUxug8cusuf2XccsMsLOFghYY+hwBOytyb02jxEwuSRR6vC4NvAvKpC8Ce4ME59YLUw263pV2fvaSq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(921005)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(110136005)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDJaZWF6WHRnRXU2cFdHV2REWlJEMjRWVnhpSm1PLzlwME1hWHVFZEdSYnpU?=
 =?utf-8?B?dm16dzl0WGVuaE1LV1FLczJuY0lLRk5uRHl0NStCdGpJd3lhcHpYRlVtUmZN?=
 =?utf-8?B?eGxLRERGNVNZMm9hdU5hanQ0UlJQRTlCc1hOeVJrZWNoUzRuVk85dVpmMVJ4?=
 =?utf-8?B?RWNNdDhnd2RiRG1nSDZSVUN6R1I1UE1VMXh6bnJFMFVIcVdTQW5SRW1lWDhp?=
 =?utf-8?B?ajlUdit0SXl1NmpBNG9VZUN1VXpPRnRZNEMraFpGbXdyTWpJZW53QUNkOUdn?=
 =?utf-8?B?K1VLeEtPT3V2S0tmcGwwSEZXWTRzUlY0T1VoVmcyZWFnd2RuT1BLUllYM20v?=
 =?utf-8?B?NjZLUVUzQWhyYUVCaDdVZ040aHpPdkdBN0p5TGdzQjRRK3pKL2JLS2l1RkVV?=
 =?utf-8?B?aUE4dDdjdGtYbWZzWG0rYm0xNlMwald2MjBsQi9nY3hBaHkvaWJYU3dlYWpB?=
 =?utf-8?B?bGYvTVdLNnY2cWxBZFVZOHcrUlFUdU45bTF0alNTTjV3L2xEcnBqS3JZdnJZ?=
 =?utf-8?B?b0RmYnlhWGxYRWc3M2VTcUJvbm5YQTNJdVlvL0gzWWVzSWloUFlGRVpwZ3ZS?=
 =?utf-8?B?eVc3STlSTXlpVFpsSVdqRC9MRkVMNVJTMERoLzBYanBINHg2dUJNbXdQK0tz?=
 =?utf-8?B?QWhURFNielhSRzMrV1l2OHZKWUtvRHh6SGNrV3BSMnZKbERvckZnQlIvZjNC?=
 =?utf-8?B?bVVMMWJwMzZRZnVZZHdmeGE3QkRMSlB6THlQajRyeTdPOU1oc0hVeHk1QTdH?=
 =?utf-8?B?b242akM5MUJGYXdOazF4YlVwUGJLWjc4dTVoa2xPa3Nqc1FMVDI3eTdRSHpD?=
 =?utf-8?B?K0NLL2xaZVBmQkNEQVNmVEtaSS9JWEthUFN5V21KZ3RUYS9UbGxQMUZ6UEVR?=
 =?utf-8?B?d3kyaWxZYjFEdzdneG43YWdiS3Z4WW1Id0xaTHg1K3ZIbjVZRXRVQWVCVisz?=
 =?utf-8?B?YXB2S1BPMUJ2YXM5bmpheDN6WTJBWEw1ZjZnUkVZRi9SMzZIUUZyTGlXREhL?=
 =?utf-8?B?N0NzTGJKajFvazFwYkZMbHpRRkJmUEIzSStpV3lLTERMKzVnMVN3Tkx4aWV5?=
 =?utf-8?B?OWNQMnIvVUhpREdWcGhiOVhGUGdhR3hIMGNIL0R2Qk9rZGEwVHhyRGEwNFdZ?=
 =?utf-8?B?bWptVjRqMlFYUWdINVQxYmNQbTlEbm1tTEtObDI0T0Zqbm5LUlFUQi9uWFp1?=
 =?utf-8?B?UE1OSkV1dGRWbzNnNWhwUUN1VHFMV2c2VjdJRlExL2UrRUJQa2hMNzRHSXRk?=
 =?utf-8?B?anl4am9jWlZkMnRmSzNTNTQ4NmFvYUdPSWp2RXdxKzA2TkI3TEZvekZnTzMw?=
 =?utf-8?B?SDBrYnN6eFVoY2ZHRTRDcWRtMFk3WHhQbkxsNzRGM3pVSDAxWVRScFpHRFcr?=
 =?utf-8?B?d3FMZlVHaDRKclhlQkZDS3Vzek5CckxIRGZoRy9tZ2RLeU1reTB5NUYwQ0Fy?=
 =?utf-8?B?NkxKQ2xxZFE2eldTY1RoSUJMQlVKRFFuWGNNVkVVdllvS25DT1IyTDVFUDVt?=
 =?utf-8?B?aGN5em0yM0ljaHRQU2R3eWtKZXE3bFoyVUtvSlduNG1HZmRyeFp1RndUWHR3?=
 =?utf-8?B?TTlGV0k0Y09Iald3MVUvV2ZKdG1ycVJpTTEweVlaTXBleEp0R2JsWitSOFNU?=
 =?utf-8?B?UDRiVXU5OVRMLy9IUVR3NExKVmFOK0poSys1K0x5MlVNOHNiai9zQXRQMk5G?=
 =?utf-8?B?S0hkVzdIU3JLOWd1QXA1Yk02MmowMEozaEZuTjdMdGZDN1ZWSmdtT0FDK0Ru?=
 =?utf-8?B?VUlGbkNLYnh3RUR0TTBCdnZORFhUVU5TUWlBU2RhVDIwQlY3S1BoSTg1Smh6?=
 =?utf-8?B?YXhzam54V2Y2bzRyTXNpNDQ1dlljVjVWNlBoUVR4L29zbFVQbktXVFpXdkdY?=
 =?utf-8?B?YnNVc1A0Y3k0MmFDejFUOHViY1ZOUW1LZ3RVUXAzQitBenFpWkFmS2hndWt0?=
 =?utf-8?B?S2k1UE9IMXZYdC9JTkZ0L1JrMkhpMGk0QThlZmc0aUFnNlRJazlQQ1plcVFp?=
 =?utf-8?B?ZUQ4RHRTKzZDanJ0NWNqaVBualV5QXkvVjVVYkRkQll3a3o2NFVVS2dTdmJj?=
 =?utf-8?B?UytIVjlaNmJ5YXBJb29sc3FvTnlENmhpZlAyWk5yMmorOEU1RGcyMVUycGI0?=
 =?utf-8?B?T2d2ZXA1ZzVpb3ZJVk0rY3lpVkNVeGxyNnErTU1KNjRBTzFWUlJQTVJXN3ZK?=
 =?utf-8?B?TUtjZGtBVkx2NzN2NUcrWmZRUFd5U2RPNmtZWnM3S2tHaWNrc2NHL3h0RlNj?=
 =?utf-8?B?M1NXL2JwYXU2SGV1d0NJU2RLRmx3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65934d91-c766-48a8-d3e7-08d9a3198c04
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:40:36.9661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wo/VwHog68mrpzZ6jYI0nPzocoSpfkFliCPO02E05ffisMYOSs10CdRZckaeRXm/aUovenVXVxE7IiJG78GX6PNab7vATb9c4ATamfkG5kE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: BM4uyBpwpAiWHS5F6ExiuQKpXSbrCdGy
X-Proofpoint-GUID: BM4uyBpwpAiWHS5F6ExiuQKpXSbrCdGy
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Get the number of pages directly from the new memslot instead of
> computing the same from the userspace memory region when allocating
> memslot metadata.  This will allow a future patch to drop @mem.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
