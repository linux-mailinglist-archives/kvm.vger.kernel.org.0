Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BB2449FD0
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbhKIAo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:44:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35640 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235774AbhKIAo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:44:28 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A902vs8019145;
        Tue, 9 Nov 2021 00:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=u0G7CVxImDYD2uzsh7aSsM/stA7sZZP4cSisY8F+P80=;
 b=Swmlr+sUBy55y3vogIWdFPZEYhfy7uOlbYRrE3x4j+d4chuSCFEoPPkmYvhYE0sB7fcm
 xbn544DAfQmJUcXl8w5j2HrrfhdSbQBFpo1UlKQvxrkEM0EALcEulF4vpqPdCp79si7p
 cunnSbkQUVgbI8DPyPWYyTF7u4EA7Db3tBIpqpKUcpYm7X/1VQRexAgQhC/XUWJ+vR7V
 pL7TjFrCNUBvSzZMLJTCeqgfYwL9YABr0zgbcD0Nc2cFsz/S1JIFswfD8FEgO3Odu8xm
 bS3GOAAFBfzM99Y333Ihk+xaOPgjiWtLoI+0hgmn7Wsb3W0woq+UKVqJaVNT/WCmORti dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6sbk7cfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aE5C062847;
        Tue, 9 Nov 2021 00:41:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3c5hh2v6hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEG7y03th/S22XX9hUt62tUWPBEJ8tWbskQDebWmQQTcEGk3iNiw27mgWeH9ZJSjAFE6kYOzF6797CLQjEK5aMMIRebJut44Cvs3lQekX79jiaTt3yDosw1dfGSF3ghbPRCIMLGZSNXHAfZILWvZQOu5xREpBsEYpiEL0F4/4BusbKgZ3p9+6IFgry7puHULx2fiXJ+5vlpjPRvFjwRd2s8YsngeNvM3QvY0Gtz7NTS3t//29odV+WxTs/HXjMg9xsUZI5ux4YV6FE5F2NDLCUxqqjZDFIsxDKZX98bwjTI+oo84GcbcsDKqbtmxdb8JTcyRur4EOhX1V/VpBPyWeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0G7CVxImDYD2uzsh7aSsM/stA7sZZP4cSisY8F+P80=;
 b=Q7grnfrKOty8kcXV7NKFmONVhzGzuiwUlshXR97r1i3Mtlozxu7LQfmS9EwDazgFZ2BmOwbgL5wILNu5kCRUupNR9NaOltf4OSkV2Zb5HwAI3oX/CvrNSNfGTwy37MhGKRS3Zi7+7iN9mEScVLPlnG6ciZM7N1Zta2sndJpB0ln1sS/57wMWElmJV7GmZwv8neb2GkYr7ZF4g3b0kRK73Q3z1YscDgM0AfG+vqtqdOT4lqc1NP0dd7xhArH5ZB3X7wJ6da/9b4AOAjcTCOr1CT45dQajR3cWOQVPBfwhq8NU/mrK14LBAXlvP4c+ydXJEW4Kza8LBLW8oubg7AoSyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0G7CVxImDYD2uzsh7aSsM/stA7sZZP4cSisY8F+P80=;
 b=wIVyZewkn+8dcmgw0X/CCeTMD4kC1gIp1hzFd62ejovfJ5+7BVra6Yf09qXco8rIsS6hDDd4gJaaNYJkyj9wIXCBl+d/tdxoAXPBz4VKchmZYzN8DzPcPjQ4kwpZ9RhgXQ9fcDwsFDdnpZKYHPbgvHXqIf0p7lKT89/rbXMA+gA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:40:59 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:40:59 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 15/30] KVM: Use prepare/commit hooks to handle
 generic memslot metadata updates
To:     Sean Christopherson <seanjc@google.com>
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
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-16-seanjc@google.com>
Message-ID: <84daccb5-9eec-011d-a0f7-a6af38a124da@oracle.com>
Date:   Tue, 9 Nov 2021 01:40:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-16-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0002.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::14) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM6PR08CA0002.eurprd08.prod.outlook.com (2603:10a6:20b:b2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 00:40:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68eeff40-30dc-4378-6672-08d9a319998e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB52737247D48B2A91B82E30A4FF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:95;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omchoUKhU7G/Va5uQMhQaPfQuQq9FzY8d9rxilwhSyeBrLFGGnyHo/eC9FaXKb/aWFTbLkyVJV3OrC93SZmW3feQRO7VVyq5Sko47YKWaoIVe1LueZB5kgZnRfKzNF3Rz1yZi99l+fx6WQntgSQk7TDj4o+8YSP7VJspp3Xov8UJCJNfcQsNMNi9SfaTVjFhEGEPzTvIBSOkvrI4OkgAH/goS/a6E5rmQ9PdgKT6eahWaguXBhrkTXyKflrT6aCGqJss+2RJT+lh1mJwLeyhs/v6yGunHIemSGYrqw7obmHxADUcI11PKgHbWDC7k7gsmwsIptzlag6jY/4o0iadaZg8pY4gG6dynNTWEOyej8lC5GSjbHNmGz08j/sjyhApylfE3DpCOBhxCXjkUfZ9iHTcyK4X78cy46kKVYl4SZzoQUhHnFv8xYt8EmYO6dUuW8cuGsHAxZeg6lxSq+ACC/e8ijVFoHsEIA8JT5Rc9YZq0niK74jJI3VO/lsmki9XvdsRQyHgbH3/NAzNENhfERgLHXrgSWfhQVYoz2bQpCnhlXUxOiF3Rg8L5hDEZEkqKvw1Js4gIPpSDLaAPq3nOTR4XbbvOGstQLWxIMP1WQypshoJalehd6vbsrmVxkRmeIsn24VLf30kMokpDz+y4O8JcNFTT21UcFkGttnqOhk3Z3N/cAvvZSIu0ki4rtQ2Hu33DjLk5nX9dGzSoyiv8Z8W4SJhpn3b2CHAFsQHfSxCE5dMMrUriJZjZ3p0ZTuJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(15650500001)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qjhwcm15YndLSDJMQ1k2THF6V3cxWVo3SWdSUndBWkpEOEF2SXd6aHdqU2JB?=
 =?utf-8?B?eDRCRm9aV3YzY0ovUTdFSExoWDRRTzZWVHhSUEF3U3ZPSEd1K2NSSG9ETC94?=
 =?utf-8?B?dGtIUzE5N1IzSmU3R2xoeDNvajRWWFErTVN5UWY3UWhZdGs4WFEzcUNtSVFm?=
 =?utf-8?B?SVE4OFM0dHh5cXovRHNvS0hCT0JUdWZLL2lXbFlDdXJsUmFjbzFjU2xOdTBs?=
 =?utf-8?B?ZnRJMzg0T203dTVXVjFxZUl5b1hMWll0RFdxQS84azdXRnZvKzZ0b1J1LzA0?=
 =?utf-8?B?MzF0N0dldDJTanBUVVA4aWpXVjVFRUxoSTQvKzJhSkprTTc4ZnZGN1E1b29n?=
 =?utf-8?B?dml5NzAvTnFWNzcyZkFwSTV1S0FTNDZzWFlZYStRQmFkM0l0UEMxVjFpSytu?=
 =?utf-8?B?dGlIUEZTZTNSS0tlOWZvSVp4QkN0Zm40ZG1LeVpnZ1NaalhWa2hwcGN4cHJR?=
 =?utf-8?B?VjltcS82bUNYSGdwanlWQk9vNjRTdjFKbHY4ZVRwQUVNYVFlUEZFUEE4Y2lD?=
 =?utf-8?B?T0VLeEZVNWlia1FpZ0UvekYzNkFwdDJqNFh0ZmswZkFZY1hmbmk0V0FvYnZM?=
 =?utf-8?B?RjNWNFFyTk4xdHU1NVUxWDA1cUdNbHFGNUdwbVRjYWdsbEFoUUdrWEZlbEZs?=
 =?utf-8?B?NTFiYkdhTUs4WnBXTFQ1WXo2b2ZwaDNXSUV0SmJiNk5JZjNUNHYwYmF3anZQ?=
 =?utf-8?B?bWpuQ2J3Q3BiYTNva3NGbUR3eVpHZHJNOEJmMGFuZ3EwSzgyQkJqY0ExSUQ5?=
 =?utf-8?B?b21VTUxzT2g5d3gwY2k2cHExUWdZSmRmQzVoajdhMVhQanB0WmZFWkFEL2VU?=
 =?utf-8?B?Y0JzaDNVcGxGSEQ3T09FNzYrNEs3Q1g1SXZubUZzV09lRTNhdGlnMGpVanRC?=
 =?utf-8?B?VzhOS3ZwZVVjRndhSXJhNFM3VmZOMEI5WnhSbjErZ2lLTVI4cGwyWXFEL2N0?=
 =?utf-8?B?RGtodzkyZzVLNW15NzdFWDVlZXI3L200MjU3SGxFLzV4WFZhSytlNnQvbXlE?=
 =?utf-8?B?RFA4bDNQT1VGTGFLdi9VTndSSlJHRHZGOXpKNExhRi9EQjFDZXFrL1pKeEJy?=
 =?utf-8?B?WDQ2Yy9BYVJsNUxtWFZlaDZYcDEzeTZkOTNRSVFpWU10TzFBMnc2RnpIOE9Y?=
 =?utf-8?B?K2RLV2RTVk5FdVIwY0dHZGFBSHZ0WEpyT1RCYVJwejAzSnFDUzdHZFVwSnJx?=
 =?utf-8?B?bHlwN2ltaDVnTEhxR1VZQkhpV3NEamdlTTN6RHhkV2sxdXkrUHFFd0NIRG5W?=
 =?utf-8?B?TUZtWC9wcDY2d2pBNFd3RnduTngwZVV6bFY4S2d5OXcxeDhYazhFR1FIVWp2?=
 =?utf-8?B?RHp1VTJJbHBrd0hoYTFlSVdiK2hBSFZEZnJDYWhXQXErRzZHa1ZuZC9rbWZM?=
 =?utf-8?B?eXAwOFR0TVo0OExPYi9YYkZVak1PcVdkWE9yUitFcTZNNnhhTWRhVW1oMnI3?=
 =?utf-8?B?dFhNdlNhN01MUVM2R0V4YjFtNWVtQWRTOW5Fdklad0JQRGFmVGwyRnlvN0tK?=
 =?utf-8?B?MDU3V1RaNEZoNndQS0pxUGI4NzdQOWdKaXp6b3U0QXVsVStwR3l4bEdpamJw?=
 =?utf-8?B?N2NXejNvMndqeGRYMzJQK004MzIzQnVpeWxlaFVjbEVLVG1NVmxRUSsxRWJl?=
 =?utf-8?B?Vkl6cXdyY2ExTTExUGFHN3dtYlRXODNEN21sZ0svSE9abUNlSkEydXQvNU4v?=
 =?utf-8?B?SXRTem11allEdzR1dzZFajNEZmo3Y2swOFA1NnhPQXhQbmp1Uk0zaWY2eTRG?=
 =?utf-8?B?OEdSUllxSGJHb09GaUs3YUJLamZTdEJ2bDFHQ3VNUi9iWjJKaWZiT2NISEpI?=
 =?utf-8?B?MUpiLzJadGJMYXJpakY5K3NyUEJMM2c1Qng4N1NRVFFWV2QxbFR2dW8wYnJD?=
 =?utf-8?B?VUhMT2RGYWhBbkFGUUF0UEhIbmxwK1RYLzJhU3RUQjdvZWxSRGNiTXozVnBm?=
 =?utf-8?B?QS9TU095WDBNN1NVZTN0L243SjZFNHg3WS8wckltMUlvYnpFeHlRSUdaZmNP?=
 =?utf-8?B?eHpJRWVQOGlTY2dnMXFWR2dpdzBPMG1kNExyL2VBZmdTV1hncHpvQks3cm5h?=
 =?utf-8?B?THREMTlGK1I5QXZvM0Z1TGw0dHk1QUZTSVJWS0pSSzYyNXovcFJLTHFKYVpt?=
 =?utf-8?B?SHh2MFdsMkpEcW9nWno2ZTJ2b0xHOG85SkpjQURIZzl2aUNzQmVNR1RTVFRF?=
 =?utf-8?B?RlVoRHlJNlkvWkpOZ2R2R0czNXFyUlkwa0VjY3N4alpPRkdRR1JLbFlFcnlB?=
 =?utf-8?B?UFBscmVnMFp4TFNKREZiMk9DSUNnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68eeff40-30dc-4378-6672-08d9a319998e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:40:59.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agFiluKbWE5ucQ6fedRlXIcmf1rbaihPiNCoWjS0jLNPouoaJVLkuBL/ZIdNR2MJ/3rFnEnFKRNV2FJlXwIXGxQrkn+oCPwgyneRI7XLQl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-GUID: 4BL8KN-eMpRww0lFSDqcHzpUBScdvP64
X-Proofpoint-ORIG-GUID: 4BL8KN-eMpRww0lFSDqcHzpUBScdvP64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Handle the generic memslot metadata, a.k.a. dirty bitmap, updates at the
> same time that arch handles it's own metadata updates, i.e. at memslot
> prepare and commit.  This will simplify converting @new to a dynamically
> allocated object, and more closely aligns common KVM with architecture
> code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
