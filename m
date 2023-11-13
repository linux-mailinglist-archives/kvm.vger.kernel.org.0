Return-Path: <kvm+bounces-1599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E23D7E9E5B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 15:15:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CAF21F215FE
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 14:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD142210FD;
	Mon, 13 Nov 2023 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RSRkQJQx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="to8tFw2N"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90620B19
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 14:15:18 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC4D59;
	Mon, 13 Nov 2023 06:15:17 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AD9TTbO020815;
	Mon, 13 Nov 2023 14:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DuOBZRB25LKm1+slBP5DM/07vlMzX2FFTrXcTT/a794=;
 b=RSRkQJQxvqAMv0XNNLsDZEL8c83bl/ayJ5cnYlhX+/4MKJJKgJVJMKnvJ3MKbRd7eXRs
 KpR3T21GOEQGzsznIbWNsQZHNZPIOQgxrt0GqS1bfg8ii5PsR+5ZMuXscCokAbgcXRn/
 0EbnxwwJ2KDZwKDhQLbn0p1UFUHiqg8tDp+Q5m3k1wyLKKKZ5eqpOR60K5ARnL7B2XMR
 se4yAQOpbaJr0stJIDb7jmImSvDc2/B+7G2g7vCtmm7TzXBLQOStXlx5sDBXRmP2YoXg
 hzOMuj8rqMub8dgHRyUcgRmpgj9+rzfsKcRtPe1IgHSCjj3YqbuMWPlvffxLPiaefwsy +w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qjjvbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 14:14:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADCfecg013564;
	Mon, 13 Nov 2023 14:14:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj0fcan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 14:14:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8eIJ1gok0Dx+k+SKVPXoWd3ix83/DSKJwIE6VbA0w9lzYtm/xwI7cY5S0L51RDMVeuLOTZWSZWQISODnZg6QMOuRns20u8WgJSUTwOmuMyo9V6bVrMA+5NXoJtepVrr0/S596zD7VmTsEPqu3hWf0O+UhTgBd1oeSe92fFbODy/MtMlxNr4gcuscN0pDPBZIH/y722/Yvm+chbEm2KyC9pXm3g/Y+VeTeiNiRXKFE8NL8kX18EJy74AXrWbpZjsduaFfmS3v4fYAYNu4dPmP9PirLhnYQojVi12kXWiva5UKA7tQKbIkzhrMYaGBE+YiXWwfmrpRrb1mqRD+XBEng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DuOBZRB25LKm1+slBP5DM/07vlMzX2FFTrXcTT/a794=;
 b=BKLa+hMVcOCdIhvTGYAxp1BUK+3K//s8H84NVRLxEGW9Q5lGYs03G3y+xP9bH1hxSXEGjafVZUNkopRH4au85ksxlsbPY/KYtm7/oZbLYi9LEvEtuoNvFagZr+9DCpuDzAzDdUbwX4FaT/mAdnlJFY720X8tRpyvFGZjzM5PnUD/IWVa+p56FymVVfOLSX82OtRk1PZ5yDLsH3yZgVhjnAHRFbH1WL+Qn9uF+w7cp91tNMDguqYcrZEQgYmmiwN1payMf+jfRGNMEX0YiXVNM+AByN7blCg5NHylcw6Y6KzufJTFgV0WlFRBFIEcWWjLek1cqFUY1fOm+Rya3bLljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DuOBZRB25LKm1+slBP5DM/07vlMzX2FFTrXcTT/a794=;
 b=to8tFw2NIpn0i/XO+dZNb4QVpqbwPajZH6SArutj1ladWpzp4ym1V5sN7sNs2SyZxl+5i5eqVTAED9tC18iNcssNO1UyEppKsFf4BffQmyEXgdwg6XOnGKXrnuBul+VrhwsANKKiSfEHCKsJxTEOh8qDKXD08U+RtejxLLXch+U=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH8PR10MB6386.namprd10.prod.outlook.com (2603:10b6:510:1c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Mon, 13 Nov
 2023 14:14:41 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 14:14:41 +0000
Message-ID: <12d19ae8-9140-e569-4911-0d8ff8666260@oracle.com>
Date: Mon, 13 Nov 2023 06:14:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
To: "Denis V. Lunev" <den@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Ivanov <alexander.ivanov@virtuozzo.com>,
        Jim Mattson <jmattson@google.com>
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
 <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
 <12aa9054-73cd-44d3-ba76-f3b59a2bdda3@virtuozzo.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <12aa9054-73cd-44d3-ba76-f3b59a2bdda3@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH8PR10MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: afd4e90d-dba5-4ba0-3326-08dbe452e07a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	tCHITWRn9qsPwuXJf1IexaumV1vZAq6kNcE2RBbB04s7aLbV5dr0TqT/cY05/tHtDvZFpJMTtuGy3u0v81vb/W/Ai3JzYXTYHBabzuU7yzXXRGZAD9Mktv0dJ8utyRZ1lybSw9dV6Y8olWi8GhZ2+Sct4mTupkEVux1m3ExITMSSzZeqamr9hK6E+wifOE0qSxXyUo4efbDpPDum7kDxSYmqFWLG331P8d6p5j+0UPaYdTRSHLP5xIBeAs3hlsGTyPGpHECFEft/vzP29Dy38Ykmeev1CSptzDoLuYVQQDH3OSg2XQx6+ENvRb4Pyz4vYeQOAPlo5Xaz0hmJabLlxN+iQawaG+XDlhgP/sKiUBL+Pj8cWXw5qzpiSvAzs407Hss9HjbwZ8Ygv+oE+JDPLF1f3tO3RW+hBPCyGKOTm0iNtAjYQTksSQhKcdWnnxnyqU3xXyL1cEzmyDO1tJQDMKzqtgg/m9HiUWV/jvAkFaTqV1+aLg+7TSBzlTl9j9iVkWmbWkGwghXwSzXjHONvkB+wcgumjSxzSSCf9W/iYj4JfQcl8uEiqVE//lYBvAWG07Xm5UtJrhBLMvxHZqmqP+YEyXHwFEYz72FhZSicNfSTeU8DvcSW2F66WUhGX+HTt7Eo+F6v1n6zv3uBTCTgZw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(8936002)(4326008)(8676002)(316002)(66946007)(66556008)(66476007)(54906003)(110136005)(2906002)(41300700001)(44832011)(31696002)(86362001)(5660300002)(7416002)(83380400001)(2616005)(26005)(38100700002)(31686004)(478600001)(36756003)(966005)(6486002)(6512007)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?KzRKMmJEa2pWQzRQaXZFNFFYek5mNkJVdVJUdm5GYTFQOEV3NXZoanhtSlFm?=
 =?utf-8?B?QkMrNUtSRFQrYTJjb0VyVU10SFVuNVIySnZIYUlidTNsM1BhNnRiRXlwYUI1?=
 =?utf-8?B?dkRXcmVaNDZSS2RMc1hialRETU1wUDJLci92cVNObTBDNWJqdFp2Q2lMWVp5?=
 =?utf-8?B?MCtPYS9IMWlxYm9VZEo5UUZOeklmK1I1MHkzand5YXJWREFGVmlWNW5nNmF4?=
 =?utf-8?B?VVl0aUxLMXdaS3lYTUpEZjdRTCtHTmkzSjgyV3ZaNzZ2U2ovbFA2YXk1cGM2?=
 =?utf-8?B?OHhuWUF6TjRXTVlXVlhyYkxYaloyWU0ycEErRTExT3AreTJLdjRkZDVvMi9r?=
 =?utf-8?B?R09zVjhGSHcwYmpseXVucDRFSklzVnpnQm9XVGdmWDdjcDlWd2NXbWFMbk5E?=
 =?utf-8?B?WFZoTWdmeU5MM01sWkRvc0tFODh0Ni9Nc3gvZHY1RE85NXlFa1hROER0ZzQ4?=
 =?utf-8?B?M1lZS3Rka2FiL25JbHlKNVY4NFFLZUlFVEd5OTJoV3NxcGx3S0NrOXZKOU5s?=
 =?utf-8?B?ZTBtOTdURnBROVJKR2E3azNQN1ZDWCtXUmVKWUZiWnpNQjU5a2M5K2hpZWc5?=
 =?utf-8?B?cWZneWZ5MnFTZlZYVnJGOWpXNGo2TzFudktnVldtY2NLRnhOZ0FaTi90czJ2?=
 =?utf-8?B?bENrUjlacUdVWXlMcG9jak1TR3dFaVg4ckg1Tjl6TVFDTGhySTRVNk5abkI0?=
 =?utf-8?B?d2ZORUFrNDMweFdQS1JZOTJHN3BycHBsSy9pbUNHRVB0cXo0Rmg0bFA0cWZH?=
 =?utf-8?B?VTlMWmVHbnV0R0wwWXp1TlB3TlltMkJ2c1N1Tk9CQ3ZHbHg1R0c2UHNHcmUr?=
 =?utf-8?B?bmIvdUdXY2xIZ1JNMmVWcktubmQvQWxOM0pYY3BjOTl1RnlyakY3VjhWa3Y4?=
 =?utf-8?B?M3g5R1ltUDhXOFAvc3F2RGFrNGMyM21ybXU5eVYzcnl2bkp0N3BDVjdjRURu?=
 =?utf-8?B?djR6bjQyNTFEdGw3QXlndU5xN3U2dUJyYnJlcWVHV2FuU0NJbzRCMFpkZ3hx?=
 =?utf-8?B?d2ZmcXFsYzBheGxkQWZ2UzNTL3RqVUJVNjZyN2Yzd0FETDNWdDdlUHpzd1dz?=
 =?utf-8?B?dzI5QzlpK05vMHo2QUNmL2MvemRFaE8vSEdwdWs0bGtYY1R3TUNoTzlpUENG?=
 =?utf-8?B?bkFJc0FJdGlsblllbWZCZ3VSTWlzRWpWOTJESDM4ais3bjZMSHFGb1pCM0Fa?=
 =?utf-8?B?cEtYc0wxUnA3TWd6MVlLa3dJY2l0WUFmMzNkUWNiaUVsMG8vWGg4WUJxSWtX?=
 =?utf-8?B?UzcvakRzMU1xbG9EN2czdml4bThHNEVRZm1TRkdqbnZic01aeHVHTzAyMjJK?=
 =?utf-8?B?V1FzMjVqbVhiQmZ5aUN4Z0tTUWI5d2tmV1A1Z2VQRDk5SnVlRFRKUjNIZnl4?=
 =?utf-8?B?WW9Fd1g3M1FibzBzMlZsY2wwKzdMbmI0YXcwdW9SOFJJZEtGZ0ZDcmp4ck9O?=
 =?utf-8?B?MDlGUk1wSWhtYzRoOWZCdzk0Z1NhZlRWd0g5aUVRWFJaZGk2T0lyd1krWVhZ?=
 =?utf-8?B?REMxeWlXdHJlclE5eWhwUWV1eHY3MmR4a3ppSlpTWWVxRzVNU21DbFFVbExx?=
 =?utf-8?B?dU5UdUtVcjFHRDlVbDFsTkpURGZMMDB5QXVyVE9ERGhzOHcwRk83dHhNVzRv?=
 =?utf-8?B?dENwM1NjZkhXYnU5eFQyVTJZQVVVaUJUL1lHTTFKQTdRQVNVYWoxTUdITnNI?=
 =?utf-8?B?TEF3eFFQa3dHZWlJVldKaSs4N3AzRHczVUJCemQ5UXdtZTZQNlFFeUNTcktJ?=
 =?utf-8?B?Z2pYL0ZDd1FabVA1OEFQYmVQZmhaa3lKZjVCb25lKzlPV2E4T21VdzZxaFNB?=
 =?utf-8?B?am9STDRZWHZBVnpYcEFkREtlSTVkYjBxWDltMUdGb1Jjc3FkQTkycitQdHpQ?=
 =?utf-8?B?K3lNaG4zUnp4NXlobzZNVElQS2pSVS9WVWVPUnlDWTR4ZHMzRTVVS0d0cURQ?=
 =?utf-8?B?ZlVzY2R3UUg0SjBhYTZyZmJpMUFXZE5iMlp1UCt0TldkYmRiVk91Q3pBT21X?=
 =?utf-8?B?SUhaaldJYzlkSlZSb1VKNFExTjIxUXA2NFF3UzFsUWxpMlhkR25IYmNMQnox?=
 =?utf-8?B?VjBuSVp3SG1BekZ4UlpaNC9mODQrMVZ5N3d0bDFTbHpsT2t4ME1mL0VlelFR?=
 =?utf-8?Q?d4uAEqRxbWaXMN4WFoQEYGBk5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?U1FUNW1VczV0aXdiYWlJS2F6MDdvZGtWTStKdDNuY3gwazZ3Q2N4YVEvbFZK?=
 =?utf-8?B?NUJYQmdreWo4SW10cVZxV3NKTWswQTNjRWZNVmd0dWwzY2FxME1PdiswNExB?=
 =?utf-8?B?TEFZTlhiWGd3Sm1GZDhJdm5GUEVwSUdMR05yYS9GK3l4Rkx4TmE0ejN5WlQ0?=
 =?utf-8?B?cVhJaHFwb2ZMeHR3eWFpOVdUTmh4STFxQ2twNWNHaVg5cHFMMUlZMzk1elIr?=
 =?utf-8?B?UDhVcVgrSHpZYWxRS3dLNEpmVC9ybVBvMzhQNHVGWGViN2Y1ZExPSzNsQXZ5?=
 =?utf-8?B?QUNXVW5xLzlNcU1DRHJZNks1ZVBQMlgwN2Y0OERTc1NwSUFrdEJxdkgxeFJD?=
 =?utf-8?B?NU1Wekh6OHhPRThseHdKbXNUdEVIRnVadlFTZExRc2pjbkptUVFRVSt3bC9W?=
 =?utf-8?B?QnNSTDhFb0ZnQ0diUFl4M1ZBYXVDTzJuSTh0VDE0QWRyZ3BaeVF5eWo3NWtY?=
 =?utf-8?B?VXFkY2M0cUltQW9mM3JlSjdGWDkrVjVvRG9ZZSs1NnNGQXFpQTdSVzRrU0Y0?=
 =?utf-8?B?Mk1MYTJhWEtDNHJEMHhoZHBraVFEU1pIWmd6aXlaTFl6Rk5yYzZLV3VKY0wz?=
 =?utf-8?B?ekJmRHVTdXp3VjNSTzFwQjR6OXVyWG55eDlPWFpscDBvcTEwSXdXY083OS90?=
 =?utf-8?B?ZEpkZDdGOFgvUXFPeEtxMlRnQ0VFUkQxVmNuZ0JkUWpMWlNBSlNUQ3BvQnhV?=
 =?utf-8?B?b0hDdGtIL1FVMDQ2VDJ0NDZLWHMxWFZpamtuNmo0SHhRblQxYTF4Nzg3UGd5?=
 =?utf-8?B?NVp1cW1Yc2VZbnlEQ1J5VTZCNGRrVDkwcTF3Z2RHUFFzS1RyN0lrbFhGYTR6?=
 =?utf-8?B?OVVFNmpvOUxmS24rcjhrdGJsSEJiZlI0NFRDNlZhY1kvRy9VaGF5OGNFR0hI?=
 =?utf-8?B?ZEZWRHFDWEQwSFdTekpCdGlEVGlxcVpSZzRwK0NjTWxQRENuZmhITVViVHR1?=
 =?utf-8?B?MjZ5OTdzbkd1U01zS2xZWlZBSlhnSWdJSkhmU2dmUUFGbUEyTWlwRkJzSUlX?=
 =?utf-8?B?UGdURFo3RlBzMThSV01OU2JLdDlvSE0wdkhQT1E1aStRekx4K1JXRlBEcEFh?=
 =?utf-8?B?WjJlcGZnWUVpcTdXZmh6TE1EVXJVMmswWms5LzBOUEhhMThhRFJsNWZWQkNV?=
 =?utf-8?B?YnJTZFg4ZmtpWElRNk1jWW9hYU05UEh0MXlvZTFwRTMra3FTSHB4Q1YyNFoy?=
 =?utf-8?B?b215djRWdmdraHVJdEhMelZyZXNLL2Q1UTMvbngwWDFQbDZlL2E3aGkzUWZQ?=
 =?utf-8?B?eWkxQU9HQjhQTlZ6OE90NnJTRVc1djFCaUpRVkZCemUxSmc3QnJ3VEd0TjZ2?=
 =?utf-8?B?VlJMQjRxNHErSjg5Ry96dEhnd1JYNTlMdUQzVmQvTkNZeFBFTnZQYlpRWDU1?=
 =?utf-8?B?VXl0Uk9EdWJlVUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd4e90d-dba5-4ba0-3326-08dbe452e07a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 14:14:41.5006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ING+XcctG3xxMcq9hWFp2oGwC/D9KZX/K9Yime1qBQWo/y1AoR49RMXQ5GXIPtUCU7UnE3Xl8DtPeL1H6h0Q4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-13_04,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311130116
X-Proofpoint-GUID: qGMVYpPCXxjnIc6otlIVuZnpi2dg8tej
X-Proofpoint-ORIG-GUID: qGMVYpPCXxjnIc6otlIVuZnpi2dg8tej

Hi Denis,

On 11/13/23 01:31, Denis V. Lunev wrote:
> On 11/10/23 01:01, Dongli Zhang wrote:
>>
>> On 11/9/23 3:46 PM, Denis V. Lunev wrote:
>>> On 11/9/23 23:52, Jim Mattson wrote:
>>>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>>>> <khorenko@virtuozzo.com> wrote:
>>>>> Hi All,
>>>>>
>>>>> as a followup for my patch: i have noticed that
>>>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>>>> disabled for a VM
>>>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>>>> in the VM config which
>>>>> results in "-cpu pmu=off" qemu option).
>>>>>
>>>>> So the question is - is it possible to enhance the code for AMD to also honor
>>>>> PMU VM setting or it is
>>>>> impossible by design?
>>>> The AMD architectural specification prior to AMD PMU v2 does not allow
>>>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>>>> general purpose PMU counters. While AMD PMU v2 does allow one to
>>>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>>>> can expect four counters regardless.
>>>>
>>>> Having said that, KVM does provide a per-VM capability for disabling
>>>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>>>> section 8.35 in Documentation/virt/kvm/api.rst.
>>> But this means in particular that QEMU should immediately
>>> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
>>> not seeing this code thus I believe that we have missed this. I think that this
>>> change worth adding. We will measure the impact :-) Den
>>>
>> I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not draw
>> many developers' attention.
>>
>> https://urldefense.com/v3/__https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!McSH2M-kuHmzAwTuXKxrjLkrdJoPqML6cY_Ndc-8k9LRQ7D1V9bSBRQPwHqtx9XCVLK3uzdsMaxyfwve$
>> It is time to first re-send that again.
>>
>> Dongli Zhang
> We have checked that setting KVM_PMU_CAP_DISABLE really helps. Konstantin has
> done this and this is good. On the other hand, looking into these patches I
> disagree with them. We should not introduce new option for QEMU. If PMU is
> disabled, i.e. we assume that pmu=off passed in the command line, we should set
> KVM_PMU_CAP_DISABLE for that virtual machine. Den

Can I assume you meant pmu=off, that is, cpu->enable_pmu in QEMU?

In my opinion, cpu->enable_pmu indicates the option to control the cpu features.
It may be used by any accelerators, and it is orthogonal to the KVM cap.


The KVM_PMU_CAP_DISABLE is only specific to the KVM accelerator.


That's why I had introduced a new option, to allow to configure the VM in my
dimensions.

It means one dimension to AMD, but two for Intel: to disable PMU via cpuid, or
KVM cap.

Anyway, this is KVM mailing list, and I may initiate the discussion in QEMU list.

Thank you very much!

Dongli Zhang

