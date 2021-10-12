Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4D42B00B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 01:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhJLXTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 19:19:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40190 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233180AbhJLXTi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 19:19:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMd6jx023203;
        Tue, 12 Oct 2021 23:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FJ5uYJ+5xRsFwN4bCFMszq0wwmUo7hc6RlI80lscPiI=;
 b=H25hBl/BBoQpzmHtosxsmLM5X9NrjG4Bq3wSJYaF3BEYHtzsGZ1xsIT0CsIQxb1WAX56
 Z5FvyxVwtMUkuH7I+1t4ZcRJa2CLt3HTy4Qy7Kk1cQ8HhSD7L/Tivgscrbk89v8M8TLf
 GyxvBRHzNNJMT2lmr567EhlMDWAmTFvlFRcRHHjyv3pDErfs8S5DOHVULT/TXkAPVbk5
 WY3S2gxGl0pWyrFOM5xlLQJf12fUSzn/aYva5a4lZuRY2tBLz/9Qm0Mv/p3Qq/4njnWZ
 V/BAzV3muxedbeD1pqtnht3vxKGeerY0mebLRZ9M92qLVrb9cgSCdZF+4yPbFgiY6ABH Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbj062w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 23:17:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CNF86Y002378;
        Tue, 12 Oct 2021 23:17:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3020.oracle.com with ESMTP id 3bkyvb1ghc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 23:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtwhSRm9rRLI9sVsA5p+Dkv+a7MECsnqKusq7+/TaJ2QYJLxQcdmmuyFnDypfoNGxm9MNzsOdkBKY0AKw6gKe0IwHnWUjA/m9g+14R3aV01s1iv7n1tcK0wAvHe6raN4oWvVMED+FBnmUBxxQWi6QH4bK2XTYNbbPJv8CHakFH8zEyKAPLTmyLcyVqK0qwZVF42ZHcumaYLELrKbWQj2x2hRWH77pLHqWYWqrrC5b4qB62iOAqLi+0jG24TonYGq4BpPfaS8RAEk5iuGrPCvUh+270nyso0BdYXl01GnRmvMbSwWLlNXnnMhE3Ae5W5mZuJeSXZNYgO3CdznGfzQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJ5uYJ+5xRsFwN4bCFMszq0wwmUo7hc6RlI80lscPiI=;
 b=izmA6anwuLb+BnQyjEmjDmLP52vkFadjG+rNtRyzgCagFgqfkvhnIkX1bXhu5bRXKRAvhOtmRtFwGgYQ9pHA7zZmDTrhDm+8RnMZiYGwh0wsvRlaoHKT9yUmO85Vmt7/7dERXK5vBkDmmq7AI8GqNqSaM0Li6Y62wVYiPSrGQXAyTRUxHa3DgjqImW9mteE0b9eSdwyo7jRhmSC4D7jTnVkWCF1OzyPcelFdWvFyYDsIwuz1Xs2aGN7d3GxK1ehkin6tB9fMt5DRaEb2+0s6IM95rYbAsTaxJkVjgPp5RI7dX91k4UceVLQT2+n/OcxDftMkkbHsI2BIJN1oQs9hog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJ5uYJ+5xRsFwN4bCFMszq0wwmUo7hc6RlI80lscPiI=;
 b=BIGDN4mJ3QY/TtCtotaZAlHuwnsKcDUc+Zfx1V4ZPl4tpCQiucmjpt44vXHJmUy2CEHK70lQ3bSVSECGN6X6z9bt7+cEOd4Sy5voPoCx3bsimTLHBX5BRF49gvJDUBWijukt5KlKOSyg09VMXWcHmvXx3hlrv6GoaPfBmeInfUQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA1PR10MB5712.namprd10.prod.outlook.com (2603:10b6:806:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 23:17:15 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 23:17:15 +0000
Subject: Re: [PATCH] KVM: selftests: Rename vm_open() to __vm_create()
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20211012174026.147040-1-krish.sadhukhan@oracle.com>
 <CALMp9eTaGfDyHn2i=fT51_GtmLmF6cXa6h1Wb_s-f=8Me1wFtA@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b0ee2adc-a15b-dd12-d297-b9754fd3628a@oracle.com>
Date:   Tue, 12 Oct 2021 16:17:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALMp9eTaGfDyHn2i=fT51_GtmLmF6cXa6h1Wb_s-f=8Me1wFtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0132.namprd05.prod.outlook.com
 (2603:10b6:803:42::49) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN4PR0501CA0132.namprd05.prod.outlook.com (2603:10b6:803:42::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Tue, 12 Oct 2021 23:17:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b63c815-c724-4722-64bb-08d98dd66d98
X-MS-TrafficTypeDiagnostic: SA1PR10MB5712:
X-Microsoft-Antispam-PRVS: <SA1PR10MB57123D134495C49082147DAB81B69@SA1PR10MB5712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXX1epAPs4J/kNI0PQvijzM88K4d/134oNnMAjfxM2z87EphnEOyEjYKBIcsnbB2zof3H1VDeHaYJP+nb6a3wExSNR0+0xRsBKDq1fX7FJCWbf43YRKOO7CwwfCI9g2HXF7eDlB/Ohn7pcLEJqYStTNM9CZNYM+hSRc+OmEL2SIPmGz9BybMhUEJYLDLOwLcoDY66sy7yMx3fcci5EtjguqS3WaHyPQpuOuweIb3onrEK0Et2MHxl6A+209Hc8ogBOH5zOYrDfw8PLzPYoxy+LcG25EjzJDgcMhtjIlAs7XzHqBdle5A4nan7a3/LbVsIatUQRkBgmUjBhXwEqcOZZ4NMFLuMMNfS7c3JMckyO4X1J/fr/Nk6+YoRdXS0SnqsJSI7ipyOP4FojQ5pMGc1maqHEaESAurYXyrEb0d0WKleiUXyDyyVhwWDYMVk/hbqoOjszhEZ3/DpJZGAsLcTfPiaVwPk1JYjKTNdh2Qt2WW/aXd9J1De7j+rTRHp2KrONwYbsUKQo4C/FhofI98rGxZ97jKFYLe3tCErECeMr1IQLF9BcKQ3EXU+H+eAhOONRV6/TF+qUFr5z/w+3OJfxqSyhGtX8UiA/jFww6hrq/ErOsclyogpJjrv3LWDyny6yuV5xem+MhEmv+adoXUVqmDd9K0fVVwq+VWtFJnTfgwCnKXN+XAm8OQe4tEH1nBaUuR1rbIMe8wK2OjWmU9XmTelf4lpCGCAk+i34QwiEY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66946007)(31686004)(66556008)(66476007)(8676002)(4744005)(2906002)(36756003)(2616005)(186003)(31696002)(6512007)(508600001)(5660300002)(4326008)(86362001)(38100700002)(6486002)(6506007)(316002)(6916009)(53546011)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2dVWjVQY1VvenNLYit1bURqM1FZU3hPSWN3dTNRcDdnaitCczh0L1hieWg2?=
 =?utf-8?B?b2p6bFd4WlB5VWQ1V05lSWwxWWllaTVLbzZZdGJjUGdKSk0wT3BZaGF2RE15?=
 =?utf-8?B?bTdrejFGc0tHRDZFS21BL2hrOXdGOGxtays0MEtaQWllWHpoVm41VnpyV0Ni?=
 =?utf-8?B?aXdrTVl2TkZOQ0NNaU1sT2xuNy9yMXhtNURiTzBXUG02TXRyRUMzQklJUnhR?=
 =?utf-8?B?UnRid1M0cHlJNm8yNzZpSlRBMlhqUWdoMjZJdTNIejYzWCt2Q1BZM0E5dGdw?=
 =?utf-8?B?MUpIYzhHVm15dWdVM3A3eEdkWC9WNyt0WGJVQjdDUjRHQVpxS0tCUVhpUWtR?=
 =?utf-8?B?ZlA5TkxuQVhZQTBzbkVTUjBldnFUU0JRcGk1VXRvaDNvWXlRbzBGYUxVbDZy?=
 =?utf-8?B?Zlo2TVR2Z3ROSFBkQlFvUTZGMlpvMVVZTklxTDdrUGMrcVkyWjlXSGUxWEc3?=
 =?utf-8?B?VUtha3JwQThDQXl5TVhickZPeGI0VitLZ0IvaEpobDgwd0JtUm8vd1NjTnpy?=
 =?utf-8?B?L2V2b1kvYzRDVG9GWkorR2ZpM0pCaWNYZG9rNnNsaWx3WFBEQkRlNVFWWUZ6?=
 =?utf-8?B?MjZjWEtQTE4xOHhkMUxSY1dkWUtucy9iM2xJZkNrcXhEVlpuVmY2K2I1QjJH?=
 =?utf-8?B?Z0pkNTU0M3Frbm9lNHBTTjV2ZDhid3RleFBEcTZOQWpaVFRXRmx3Y2crOVky?=
 =?utf-8?B?QkF2ZkVlek9KNDkwT2NWZGZ2MGVkcDRnRkF2SlZLdnI0QVRQTDU2ODBRa2pP?=
 =?utf-8?B?dDdvV21CZ1ZUaG1hVEZadk85M2FXQ1JxbFhmQTJrY093RTVHZWFkVmdCeld6?=
 =?utf-8?B?bk15d2xNS21jcEc0R29TUndCbFlyTllhbkNTMFMrN0syME9XRVZLaG9kL3Vz?=
 =?utf-8?B?cW1oNnd6ZnBJamhLdXA4cmNIcGc0YmdwdFN4cE13MUhkMXhobEt2Yjd1dkd6?=
 =?utf-8?B?eFNCNWZGYTAvMHVJWmJUaFJEdExQeGkzZmRwNEhON3VpckZMTE9Db3pFRGIw?=
 =?utf-8?B?VS9TUFFXOWJPYnNuUnAvcVlOSFZtVDRxRGhXYnd4SnFWenZuQUJtNlAvbTlr?=
 =?utf-8?B?U3RucXkrNHRLdDJ0ejNJand4by9MYlZQY1l4S3lvT0dkaU1IQWxHc2x6Nmhh?=
 =?utf-8?B?Ymx3YkVjWU9yYlBXMWc1Y2FKUHlRVFV5dEhKY0RWUi8ySWpIbTA5M21lMkdE?=
 =?utf-8?B?T3ppWHFwVHIwSGpOUU9wY25GV1IxcUxZMU1rYXYrWHUyMEROY3p3bm9DWG5L?=
 =?utf-8?B?MStKWnpVd0FpRVNnQTFzVk0xR2VnUnlTSWIxTzk5VE1WRFFNTzBSNHJzY3lT?=
 =?utf-8?B?ZXljemtBRXJ5R2o1NE8wUGxsbFpYd2U1SjRzeXdtZkY1MUdZZWFYcnl1UXc4?=
 =?utf-8?B?OWVvT3I4TnZJWCt4dzFWTG5GWkxtUDZMaGxJL3A0WlZLS1ZsRXRvZmswdGdQ?=
 =?utf-8?B?NTBhZzBsYnhLR3BIZG4wQWNQclFnK1lZOW45bnpkSTZkcFVZck1ON1VXUlgy?=
 =?utf-8?B?Z3RHbkRrbjlzUUhma002WDZGZ0dxSmhQeVhDbE1Rakh0YW9MbE9OYXRQUnJN?=
 =?utf-8?B?OFpVRlRCSWY2bm0xdmUxVXlCSHRMSEFLd1d2a3RIYVExS283SDQ1TGtPZlVj?=
 =?utf-8?B?NUFxL3pha1RCZUtRc0IzemNDNklMUHMwaXRGNUlxMW81THl1aUJCTHZMb0Jt?=
 =?utf-8?B?OFFLR2JhM1BYalNrMFA1dXZJTGJoSVp6Qnp3YjRFWlVrcTdjMTZ6L21iY1Fy?=
 =?utf-8?B?eDRjS2phRklkalFDajdlbHhqQ3c2SkRINlR6Z0V6TkZjbDV5emZzT1VoMkVQ?=
 =?utf-8?B?ZXBMUEI2QnRpWkFvR2NmQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b63c815-c724-4722-64bb-08d98dd66d98
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 23:17:15.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIZDtGaUBdP6SNOX3aN53ZwhMyIUhd3zvRjKsFDp7eFOnrmtL632rA5v0vxWXfIroDSSFNW6aQZ4d75BIN1IqWFpwX3AViDxK6Ts4NSKd04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5712
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120125
X-Proofpoint-ORIG-GUID: INBuT3hRsXG4CEtG7l1C5skzbRCcOoYI
X-Proofpoint-GUID: INBuT3hRsXG4CEtG7l1C5skzbRCcOoYI
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/12/21 2:14 PM, Jim Mattson wrote:
> On Tue, Oct 12, 2021 at 1:43 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>> vm_open() actually creates the VM by opening the KVM device and calling
>> KVM_CREATE_VM ioctl, so it is semantically more correct to call it
>> __vm_create().
> I see no problem with the current semantics, since the KVM_CREATE_VM
> ioctl *opens* a new VM file descriptor.

Agreed. But the KVM device is also opened for many purposes. For 
example, in kvm_get_supported_cpuid() it is opened for getting CPUID 
stuff.  The purpose of opening the KVM device in this context is to 
create a VM and hence I thought it would be semantically correct to 
rename the function.

