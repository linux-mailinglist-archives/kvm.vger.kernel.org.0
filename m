Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C422C62B1FF
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 05:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiKPEBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 23:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKPEBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 23:01:39 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51021D0FB
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 20:01:37 -0800 (PST)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFJK6P2025865;
        Tue, 15 Nov 2022 20:01:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=g2EuKgFZW5BaUjUeDq6oUEQZGQd4qlYA3oyu1zoJNUI=;
 b=jIwwB/UMAvKefaZ0IG6wVybOZW3TlaVSO+m1T9CJmKD/DSP9+BE7EyLUMj196KghIUHj
 S5PxxYVzbhdcNSj1w5Uc7gZvEbTTHqvqarazZiqKG4oebM1AAtlaVZU5yeK5B5qXAyas
 BTLTbQ5lT5GhBXdVokm3G/wMdFR3yZfkLfUWYsVKVctS9CyFBnlGrzOEeOOB8qpZr2+q
 nKEwEVaSixDYzAxLr7dzq90243Xb9jS9Yl4wKQryNqO7Ac7myCrKG/KVYkGDBWorDDdy
 AtU57LiJnvj3k9eZMEoS+p0sljWwvPh0W52vZK0kAYvNghzAJavwbG+tGcO/xq0ZaBf5 sw== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kvgu88v7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 20:01:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQaaPE4M2UOkca+NnIR0/K9neJKt420cQE11qawGGzXollxZlrMYjbndvFc8sGj8rUUM8sm/Ms3dl1TZmY/373mqLdyn9XWYtzjRltePjVCSu+M7nwhbE3Jbo9e0P6Ao39fbClX0F5naVCvFLbDRuhxAKC+iYf/xwHwuY4zdqtsztjnqwBNgMRzQ34phT5zGZIRMZKS4jlU78eeuw1F6nQH1/vjFPsCFvu8WDEkTJq66iYHJnhAQ7Py7YqNPuBRdtuIWPVXHz825MC9AFNEjBTYGNq4TBRQpY3OwSp8E9lQp3KFu6D22cdYtBmVdQKFaivn6jP0/4fjO11XNpHjtLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2EuKgFZW5BaUjUeDq6oUEQZGQd4qlYA3oyu1zoJNUI=;
 b=f6FyaOmuuRGRaprHA0AJj/5DohbanTecksFIOx21CZyhMa/+Ropx55kwSWQBcmPVfftUkL1jNKV6VvOgCTznf4goD6OlZWwHj7BnE3mttmPP8b1T0yAdWdE1vJWbF8QHdBWUfk7UcgxFgPzmuye+E5jGuaTI8mT7/caZ+H+/c1fmYtNnTmRWwGYmrd5sc9Cq44hdvE98/LUTlNMtvUW4X25YmTFPXEXVTPfreCejADfGbIyNinMSaaYYE7tMHJ0o++SUAsvjWpwhHcrfi+4uUZCR99AP+J7J1ujsum6NN2E7ox00BURcvly57Hv1Fejb0/ftY8XJKk8nN5HPctC1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2EuKgFZW5BaUjUeDq6oUEQZGQd4qlYA3oyu1zoJNUI=;
 b=IQhFZ+ru361PA2mG8G6VPVoEE6S6Nz1Kr3vPLYLD6pcG5NOCiIh7XyH7lSO44x3emYUzGD2hZbk0u/sBkt6mKYwdRZy0UWKtvkYiV6znn/ro+vRYErVDCPDGJIUQFZ3lUWZ5DvzH7JZwiJif/N8ZfSTFeKtMe4mZsB9rMXGc8sdi9iI5XxEUwOta7hrY/pOFKYmQHR/RlzdVwz11zCVT7z4im1XjgFiZnR8dweP18qkohAE8+gQjPOXcN6tyUBL/USKTxLYN1zDrUyS0NegI69mE++4EKmNaWar7K0MiYRBT7wCT4ORv9N32I1dUxp3OSuCHBURahzRMCeFZpdQzmQ==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by SA1PR02MB8429.namprd02.prod.outlook.com (2603:10b6:806:1f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 04:01:22 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b9c4:9540:a2a6:286c]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b9c4:9540:a2a6:286c%3]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 04:01:22 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Bug report: QEMU/KVM: INIT-SIPI-SIPI while CPU is in SMM fails smp
 boot
Thread-Topic: Bug report: QEMU/KVM: INIT-SIPI-SIPI while CPU is in SMM fails
 smp boot
Thread-Index: AQHY+XAWzwQp9gDz4UC3lFrXDBtzhw==
Date:   Wed, 16 Nov 2022 04:01:22 +0000
Message-ID: <DD266655-3D43-4321-B541-3D50555CD216@nutanix.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8041:EE_|SA1PR02MB8429:EE_
x-ms-office365-filtering-correlation-id: b69b57ed-12d7-43ff-c5c3-08dac7873951
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjYA5cSx7JfsnNjDqRf3rx6Ml+5gKyeclwAdn+l3DtyP4k7iUgVBRvn4MsiXr3okIbrsbv9iJGSsUNwWau++9RmxyrOM9BAapIYJBAK/Es+JsLxF/1Y4rh4FoU35A7OTvQdKW3dF5JResUi4X1Tp0Eqxq/BJYuvI4gmiOkFjKvxqluWWjQVdmsTkR9K49pmMMiInre8NyEXEJjraxVNmMU41C9MNwXf0wVMAxgt4xHiLnaWBt7BAl8pW3BJ8s4VhPWr+x3k7aXBI0aWm2LYjtcqznRoirp5CZeEYMU/zxT9rbVP0ILNGU9UJkxwXCiUhBz8dYPFORcyrw3OOBc4QI/yALH7yPsAn2iMjfCrPmcGuSYMFaPIFWMyyY/JG5PZO9vQr+B4E8+h1AzDvZ+tBgf7MKCMfOuTmFtetVM8gKvx6WR9uVLMSSuEBA4KUpU32tn3ocGXWOZGIyxqfGMBR/MNcrp2ayR2f+LrvVRvgLrFrGo1EL51cTRy343B9nsWRpccpaFJOHwoq62toN0Y8Onms0soAnYNMH7Zoqr9qFHMDl20P0KUzZbm2DriEksAtppf444CU5ZU8CTpH9gvk8l6cS9HLX5ER9+XM1hWb36+O4EFBDmfRWw5F7xxRHpFQ6/m/r0q1CpvjEw4hRgsU93ngfmMX+SzjFVhe7d+51WAXIlrfl378cW21+4ag2NTC3d7IJTYDQpmx6D172Exn504IMrXcZuSqAJzQVRFf5HbEcAeHz7oSKA9FJu/1mLj8U6XL+J17YewlucOaI38MNWY6G6A9OP8D3D8LaoVmPNhqQ1w+92z3d3P4ym687HSM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199015)(316002)(76116006)(66946007)(66556008)(91956017)(66476007)(66446008)(38070700005)(8676002)(64756008)(186003)(122000001)(26005)(6512007)(33656002)(2616005)(6506007)(110136005)(36756003)(478600001)(6486002)(966005)(38100700002)(71200400001)(44832011)(2906002)(5660300002)(8936002)(83380400001)(4744005)(41300700001)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0dyU3JXTWlzajlnVjFtL3lxakVnRnhLdnZIa1J1OGM4bUR4Y2poMXNIMTRM?=
 =?utf-8?B?SVljbmRJaEpJOFFZWkw1VGlsYU9waFhlNEtZWTk2VkdWWWNpcFMzRStpN3Rp?=
 =?utf-8?B?czJxd0l5OVJkcGx5dWE3VThVcUZJb0FTMlpPQTU4a1dBRjZIR3J5bktQbWFk?=
 =?utf-8?B?K3J4Ujg4b0hqeG0zRUxoYTZnSWN6Zjl0RjV2V3l0eW01NkZmSzZWMG1RaEZD?=
 =?utf-8?B?R1g5VUswNkNYTkFPV1F5KzZSbE1iUU1KM0ZleDVzeGdHS2lxZXA5VnZuQW9I?=
 =?utf-8?B?d242YzRmdExZWjlaWVF5N3F1UnRDN3Zha2NsVnJ3SkV4cW1JOUpLNjlhRnJo?=
 =?utf-8?B?bTF5dUxGakR6T2ZhaFBLdXJLdjNSWVRaajlVUVhUTnNTaks0UU1zY0MybE9H?=
 =?utf-8?B?cjJBc1c2Z2IweERKTTFxU2JCNFR0UnBGak14MlVNcXRtZlI0SkplUXpnbzkv?=
 =?utf-8?B?RGRmS3ZlRkt4dG1HODZ0eFJtNUw4RTRQQlZTWjFSQ21aakcyZ1dMVWtmZ3lW?=
 =?utf-8?B?Y01BOWpnMG5YQTlYQmozTStrZUF5VHROVitxMllQc3Nld0svUnpiZEUyTjZV?=
 =?utf-8?B?UXpRQWY1NzJhYyt5VTJPZ2crSHdZeGM3bk9COFRoc2pEM1dUUjdaeGtqS0R3?=
 =?utf-8?B?NFpQYWJSZHRzVzJsckR5Q042MTBtSFNjRHVyWGs3dXR5a3B3b0ZsWGpZeHRV?=
 =?utf-8?B?NkVXbE80cFd0aFdqVUtxVTNhZHNoRUd3TGhSZEg5azJtdzlkazJQVVVEcUR5?=
 =?utf-8?B?S1ZBRFE5VXdWZk1LN214SGFhZDJ2b21oOGlKYnVVME5QSlljSUlZV2UwUXd3?=
 =?utf-8?B?VFpSbXFvQ3hvdUNvOHNOOGRSeHZzQU5iWi9ocWNUMFJhejBJcUh0VFpnWUdR?=
 =?utf-8?B?Uzl3YlF2QUpna3hNMGxkd05XeXBnWHRmaGxjeGc4aGc2cUh4M3VkOC9QUjRM?=
 =?utf-8?B?VFRBWFlpdHVVbFd0cTJhVEFxU0hLdll3RFA4dStETVdQcUwxeGRwQ2pORGxt?=
 =?utf-8?B?ejJ6dEtpRS9jSjRHOUN1eXZybDVFZXNVV2I3NlRSK2V0VGQxS21QcHQyWW9Z?=
 =?utf-8?B?RVp1YWdVd3BKdHUvZERTbzZ4N1JNMW1Tc2V6TGt5WjdlSzF5WjJaS0YyWVRm?=
 =?utf-8?B?OGk4eUREekk2cGx3RUFDZjJRbTltbHJpd3k1dHk2aWtON2RtbmdCamgzSDd5?=
 =?utf-8?B?aVNvQ0FWSlM2b0xrZ1BxWm1pYlF6dGRMTHVKOWJwK1h5RDN4ZGNvLzZQZm9P?=
 =?utf-8?B?R2tXd0JjS2YxV3JPbVhuN3FtTEdoZjBpOWJRMXEzeHZ3REllYUpCOGtQd0dR?=
 =?utf-8?B?Y1RxK285WDNuWU43V2ZYdnhxOUdKMFE0T215TTVhQVBsTWl4Ym9saStDc2Nl?=
 =?utf-8?B?QXFZaldveHoyVndKOHI4K3JOV1NaYUUrT0hqV0lBZ0Q4S3ErcGZhaHJFYTVW?=
 =?utf-8?B?NTk2ZTBZSi9oMllFbVdCZzBBclB0SWg5d0JXd1FuV0FPS3JwR2Ntc3NwM2h2?=
 =?utf-8?B?MEo5UTVycUVIeFozNnZySUczSURZWHd3c2d4QVFzOTlKcU15TXZvOXJ1Slc5?=
 =?utf-8?B?aElNMnVRTnlxVjFmeUtzQ3k5VHlHNzNwdmFaUnJmUktLRllML25MMmlXWlVS?=
 =?utf-8?B?WFJ2WGhxbUhBNHBLeXhYVlBmL0phaGdkeGJsM1hrOGxyUjMrbzJ1Y3NFc25t?=
 =?utf-8?B?dGh0SGk5R3ZJbVVNQnZJK090ZlZ4d3hybnBOVk9qaUpCenJKYjlGR2k1ajZn?=
 =?utf-8?B?NFpPcEJtQkc5MHZ0NVByMGozMUxVdHdSVU5JR01yOUNHU2xCNVZLU2FETkQw?=
 =?utf-8?B?UFl4K0Y0bmtWZFVHN0FzMFhXVVdSV0Zna04wS0ZXV3hxVCtETFNiYmtuOUNq?=
 =?utf-8?B?L0lhZENDYmxlNVRsbVBMamlzVVIzbnhPdXpkNlliNXUyemlMbTQvQmVESjNX?=
 =?utf-8?B?enFINkVJdU92UWlHSHA5QlozMzZlR091cFExeUYxMCtnRzJHcXdKNExybm9C?=
 =?utf-8?B?UUdoRjNFN0owcm1IUzRRZnpYcWJrdVZMa01YZm9ZZ3NwbitucGxldDI5Y21C?=
 =?utf-8?B?YnppWVdIQWFGSzl1OURadDJlbTRSQUlyMGlpZW12Z0pjWXhZR0RMYTZFcVJ6?=
 =?utf-8?B?ajU1ODBBR1FNenVud2VVVEVzQkZmOVk0NFUrcUhPZmlEV3l1amdoVDVQWlow?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E9DA91A742B5E4EA362496A144CA025@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69b57ed-12d7-43ff-c5c3-08dac7873951
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 04:01:22.2206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IYnNKu/RdbG3v50FBD7sc4uCeIYYg7lsjeB1JlvdO/S9A9D6Wo4YxF4LNTMQ7zkGjSO6WXG9kzg2aU64cL+XZVfD4T3xQzeLIG+IV251w88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8429
X-Proofpoint-ORIG-GUID: DRB9b2T37_JKIwKj4p_0OYcu_RKZcuY0
X-Proofpoint-GUID: DRB9b2T37_JKIwKj4p_0OYcu_RKZcuY0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGVsbG8gUUVNVS9LVk0gZm9sa3MNCg0KSeKAmW0gaGl0dGluZyBhIHJhY3kgU01QIGJvb3QgaXNz
dWUgd2l0aCBlZGsyL09WTUYgc2VjdXJlIGJvb3QuIEl0IGlzIGNhdXNlZCBieSB0aGUgcmFjZQ0K
d2hlbiBTSVBJIGlzIGlzc3VlZCB3aGlsZSBDUFUgaXMgaW4gU01NLg0KRm9yIGRldGFpbHMsIHBs
ZWFzZSByZWZlciB0byB0aGUgZWRrMi9PVk1GIGJ1Z3ppbGxhIHRpY2tldDogaHR0cHM6Ly9idWd6
aWxsYS50aWFub2NvcmUub3JnL3Nob3dfYnVnLmNnaT9pZD00MTMyDQoNCknigJlkIGxpa2UgdG8g
a25vdyB3aGV0aGVyIHRoZXJlIGlzIGFueXRoaW5nIHdlIGNhbiBpbXByb3ZlIGZyb20gUUVNVS9L
Vk0gcGVyc3BlY3RpdmUuDQpBcHByZWNpYXRlIHlvdXIgaW5zaWdodHMgYW5kIGNvbW1lbnRzLg0K
DQpUaGFua3MNCg0KRWlpY2hp
