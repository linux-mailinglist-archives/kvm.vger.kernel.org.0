Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5687C897F
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjJMQAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjJMQAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:00:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD3CC
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:00:48 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0vg5025045;
        Fri, 13 Oct 2023 16:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=sE2GIL+Iguskd65BF/9Z44RqBAsQnJBSRCMjqFQq1pY=;
 b=qlias2StZHRRiaZCV35+3L1ZOCj8fDz8/5zAES5jlMwIBcTuiFjFxvG/l4rSaPMWcd+K
 m1P+dtSasaJtb048uJs5OjlOsxcNWVe6WDJSOZoILX5mUbEAUy9D2supxe377uenO57O
 qdeCptR8qvyn8FtEZprqySP3KwXOsWUTC8ryLflyTQ+sZij3LDGGFp0hG737IzYr3Tjx
 OY885KWg7xMi25QH5Dz4fAO7/l1Qv8BPueWq7Fp2aed8A1xlpF+09S4SCsblLLTnn/hh
 Op9wAMll3+97BC0fGXelc0b7Rn3t6+rWOhTBHEOhVycOFv2yBgoJTXNABh3FeMxRKJVM Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjwx2dcb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:00:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DExGtJ020187;
        Fri, 13 Oct 2023 16:00:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcjs3pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:00:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcg18SmEmYPxadgxYdfQ/E6lmqsyKAT78wuaOxCVfNlcBBmdxTaow3B+tIzOTDTkYXy7SK9B2lYYfgh9cFHpmxq+eUtmCItBGdBgYu6LSZACreL2HXn3cNsXaRHa4fv3cpIv4C+uC8hKPp8LqYqAjG8jSFvB9qvXIU8pt97SdgVmwvtl8Wv8YW8OiekxzZ7kEePqXchzF2U1AJHELmy+sHlHC0kHhjiNHip/mpwVmUw709fhzYG6scYbt0juUQgrsM50WIzs0CuiRQzG/Gm1S7gveurESjKPiC60QC8NxTIZ+Xh4qH2HRHyspKxXTu4I77hCqZQzp9VVn4VSpexF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sE2GIL+Iguskd65BF/9Z44RqBAsQnJBSRCMjqFQq1pY=;
 b=fLr2DzmHlUuPWIS0/oQC3T1ogi2FatGXwZJH6DbcsmJUsEVypfre9lCZdGVANBpefcYkDFezcFVGzKodULbaPkDxum2iF4HqjPPgDHSko95LzcZYKFWLY2SI+IIKQcWwXfGvJrgIQRphXNz1oMI8uYKbG2Ja7wLB8FUr+CsZ+e40wjFh/ZgHQ6vvTYxkI0aCYc7PnYgm1PBlBlG0dBvDBEOnXAULbJ0Z9N32FIInvtca5tJOAR41EcYOzdFcQGqJW7WEZgQ2uNhZ3L3AvBpnLZ6OyQPWTHFQ2oYFBXQxMjAX97LC8lCiZ6fJC0/FTGZSX/ZS96kT5ol63ZOHNFY0qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sE2GIL+Iguskd65BF/9Z44RqBAsQnJBSRCMjqFQq1pY=;
 b=MRLkdNwP2l12NYdC81lHVpl4JHJcfnsljgfl5+8oAfeXci3iMwZLbazUE+qHenY36rvQCV6+t+nxFyOYazYcactZhTHJt7Vfn5Mdr05Uy5cmPUrr6TwRPmO4QVvk+EKWJX+flMWNOeXMRej3wuibLg6IIu9IWbdkGIMrRZg7VD0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 16:00:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:00:21 +0000
Message-ID: <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
Date:   Fri, 13 Oct 2023 17:00:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013154821.GX3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0009.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: 278df4da-d970-4797-d0ab-08dbcc0580a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78IHS/wGdhUD0ouoGaJom52+vjj0snGlNzTZ3tDwgmM2i8GDeCSVO33zmGjbvx3/R2S6radq7lmgpxXWlq5XXP37r/3qnCwI375GuwaidoyK0Df5ojqxDH0WBcPeEseZsAol0k5dRGF1cXPD8mb+Cjn4T+u75Z85UluaXqj18iRNvKA8NvkespM7yE6RGqaDCtWO9/dpuD5E+AYIYxAHmvsw0Up/ckCK94OzDU1HpZHhC2fD8A9aqY2ZkpCt883NJdkiR9EUZjqIULm0k/wDVCQ9gaHsFoGCSz9anhPRF/EvhHJF/FO6F2RfSeY+RbJrKMNmowHFgS3dmNdOHmqJfzO2ULjJ64LlfulV7Cp8bXJQ8eJkpYZnsHG5KDIyagw1dVzLyO45uSvxhFxdVyrf9jOEAbC2E0tqbmQb5Xv4wfnIgVwP8EbR+sYuTFcg6UBcsTNPooBWK/KPgyBzytFZTh2POOT5zNpdPBmoGAtfzgQTpNRApdruiAhyLi7BgjUIYynmJOHB3iXu2gGcLfsi0fdxmyiz4TwicO8ikByzYfkeCmxZj0hvNWq8621NyOP/OfxBa0LCgJ4pkkSRHbEpkNAqk7GnKmgd4jYcHkJ/UQ+903UkciclOqBxi2cV21cNWpdGvVZn/UZIHDtLD5N1mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(396003)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(26005)(2616005)(6666004)(6506007)(6512007)(53546011)(478600001)(5660300002)(7416002)(2906002)(8676002)(41300700001)(6486002)(4326008)(66476007)(6916009)(66556008)(316002)(54906003)(66946007)(38100700002)(8936002)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3d5QkM0S0RDeWlBSnYxSGRidEw5emJ2c24xSElRZ29ETkE2SzdpMStaVDFp?=
 =?utf-8?B?UzBCZUtiWkNYemVYSlhCemJhamx6dzBNUVdHemJOZmtGUGx4OHpTVk81SDNC?=
 =?utf-8?B?VE1Hem5xTzZSVDA2RUR1c2VKY012VkZpck5IK25YNGZGK2x5U2dIcGx6Tzgr?=
 =?utf-8?B?ZVhVMktHQXQ3WjV5bUtGOEpIN1RiYVowNnp0N0E5Y3NlL09xZkVQM2IwTnl6?=
 =?utf-8?B?T0lvOTV0Z1pXQ0xYTm1jbE9TNE0xbExNUjZzWUFNMUl6cWN1Vm5qTmlxUlAy?=
 =?utf-8?B?SU9CSXRDZG5OK1poK2V1V2JKTXZPVUk4ZlVVQzI5OWNPSjZocEwvZEl5OXkr?=
 =?utf-8?B?OEZ2V3dWTXhZbE5NUmZBTTVBRWRoaWVvZ0dxRlhqbFJIUkVMd3ordFlzbDc0?=
 =?utf-8?B?NzFiSU5IMm5GZEhBT2ZvNEdxNjZ2azVSUXBFT1NaN2xZRDI5VDZUWHFiNXp1?=
 =?utf-8?B?TjRaT1RsdDJVU1VoVEFvelJGYmJUblNxVFdQRWYzNDgwcUJPMjZMdkFLcEJN?=
 =?utf-8?B?VTVzUXFKOHZYNmtEOS81ZnVtMDJNWC9VNUlLR01rTmw0eHJPZUtGS3lidG5Z?=
 =?utf-8?B?am41MXFZTE80OEE2TnFxSjYzcCsyTFk5TWdYR3lmZko1aWNNOHFrSnRsMmxH?=
 =?utf-8?B?d0hTa05jK2p6SEtnd3dqRDZtbnNubGJFNnpRNnZXbk9jSFN5YjNRNkN5SXAy?=
 =?utf-8?B?cFBkOEs5L3YrbnFyait6V2w5bngzWGtqOWFxQkZ4TlZSYi9oNzlRK3IrTUxP?=
 =?utf-8?B?M0FGRFRvbmVxcmNnZHduTDA4MGJxd0ZyLyswbm8wVzhObXI2UitCRE9rVjZS?=
 =?utf-8?B?MzY1UytNdkpyTlBodTd4VFdSTHltMjU5clRKWjNSV3NINkxnZ3FyWVR4Zlpz?=
 =?utf-8?B?aGgzMjQ0bGdUYmJFMzRYWWVjeXhSRG1mem5GZ004b1N3Rnl5WGFkWGlDV01t?=
 =?utf-8?B?NW5YclFaak1yNmhjUGN3SFM5UUhjQlZTdmgvUGlrTGpwZGE2T2xCSjZPc0sz?=
 =?utf-8?B?R3hXUEhIdFNFdE9wVm42YmlLdFZZaVdRcVJDdThnNzNHODNUUXVILzJBS1ll?=
 =?utf-8?B?RlYrcmJZLy8xcFF4UmhQcXBwTHR4aVhBamNOVjhIWnFxeitzS0I2WVlBdVd1?=
 =?utf-8?B?dUEwNkcwbStMdUpLeVcxYlp2MHFJU2tQb1dWRlljRzhZdmJGb0ljRTJ6Yncy?=
 =?utf-8?B?QWdyRmtuaHhDS3NVWmRNdFNWNVRBUGhybG8yeGErRmNrUk1GNW9mWnB4Qnp4?=
 =?utf-8?B?bXc4LzdwUVlQSzdzekRJR3ZlUm9BV1U0WE1PL1pwK0JDNWQ0VGZRVk9SQnlC?=
 =?utf-8?B?aE5NRDFKV1dZcXE2TmNSQ3pNbHVUQlFvVmV6THh1Zyt5RUYrVGg4RExnUmVZ?=
 =?utf-8?B?M1VMYWJBSzFkMzlIa2krZ2RDMHk5SGVsaFZzSzJDM1YxQzdleGpFTnkya0pp?=
 =?utf-8?B?TVZva1YrVHI0amVac2d1dGpWRjR6Sk9RZnRnRUJwY2pHeUpGS3E4TWNIVDEv?=
 =?utf-8?B?bk5vSE94czBNUXVnMmc0WWJ2Q3g4VHN5UlNWNlNsbzEyakhzZDFaV3ZvUFps?=
 =?utf-8?B?MGhXYlpmZ0xyUER3RWJMWEdOK3FKNXV4aVptT2gvL2xuUW9LQUNrLzhUMkZt?=
 =?utf-8?B?ZmZtd21lMjZyb04zUGpvV1Y0YjRSbTdSVDhDUFN0OHZEOEVnYlJRamd3QXNx?=
 =?utf-8?B?RWRpaTAzUXVKakNZUzFhMXNRS2YrZnBlRUlYQXBYWkdEdUJ2Z2F1SjgybE9W?=
 =?utf-8?B?RVgwb0hJZXBJb0VPMHMrM0JueGNzYS9PV2NCanRBUG9iQVk0N1pqVTBWUlo5?=
 =?utf-8?B?YlpEL3QzcVRUZi9PY1FiV0IreU9mM2VYMndBQmE0bjhmaFJjZ2kyd2hkYjMz?=
 =?utf-8?B?TVVxVjM4cnl5V3RhTmZIdHJOQ3hVL1ZlUWxVT0NTUjR0bXVxQkRvK2NsM0Na?=
 =?utf-8?B?N0xPWkVKemNSVDBEMFVYb1BETlQ1NmdtQXpHQ0h0NkJTNCtrSkVKeW1zS01T?=
 =?utf-8?B?TXI4YmRnYXpDcXdDVzFQdGRCS1Y2Z2t5aVo1QjU1QXZWek9DRko5UWNtTzNU?=
 =?utf-8?B?dTFOckRYMVRob3hSeVQyTWxZTjdSODV5Y0tFbUpUT3hoRnhZREVJRXRGK2pQ?=
 =?utf-8?B?QWxtNHNYdEI5aEpFSjZKcDExUGRsN29MajgyRktRZjJBc3pVUnRUWFBpL1RL?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RTQzdldjTkFsWnJ1TzNwWHFwTFlkL1ZqTDlUTXhHR0JndDRjcHFaQUkyQTFF?=
 =?utf-8?B?RWNpUWJrWTBVeTh2QlNFc0YzRHRzM0pRVFpqalh3a1V2b2F1ZDJRbDF5aXZR?=
 =?utf-8?B?TkFQRDhJMjA5QmVIbUVGUUwxcWt5SkE0elM0Ynpzd1c4VWswN3ZDVVpDdlpl?=
 =?utf-8?B?Q1JEVXB6QmlYM1p4U2R6VmI0c1RwVkg0a2x6N2ErUUxUUUlhdTVyUThpSGJH?=
 =?utf-8?B?ZjVsaWc0WllaL29FNnJDbklCQVEzYXExMXFUMVRKL29hWWtPZlVVTFQ0RVdu?=
 =?utf-8?B?ZHNnalRUTGNzb29WT2llb2pSTmVtaGxoWFlaNUwrZExQZ2NPelZDYzBuTXBj?=
 =?utf-8?B?UTM5cS84Qk1WcmxkaGxwcVlVWHBGNVNaQ201WXlOd280WVVxd0RRVFEvR09o?=
 =?utf-8?B?SXV2YVptVjl6a1lVbFpBQ09sN3V5Tnkyb0pERXB2TWwzK1ZsS3FCYzVlQThH?=
 =?utf-8?B?ZzhoOW14cnNwMkhhK1RuZThRdEZPd0JJYVYyekl3VXlFY1JZZEdaYytZTU9n?=
 =?utf-8?B?NEh4d0c5dVNURTZSWjFDRjRKT09MV3ZyM01WQVorRkdKK3daUW1ONE1vS2Nn?=
 =?utf-8?B?QnNYdlBxSHVnc1VuUW5TUk1JaDRMVnJ3eFNLMlhUWW5tOGU0K3RXbHpVRXdT?=
 =?utf-8?B?YkdGNy9Sd0xEK2RWcUpOZVQwbGROeHZiMUVDd2NsUVUxd2YyWW5Nb0ovRkxP?=
 =?utf-8?B?S2J6OFFJVWZlZDArdi9LK1BwQUtTSTFaMzgxeU5Ed0pSK21GVklpVGQ1TS82?=
 =?utf-8?B?TlN5VE93aEUvYXpQc1NOQXovZ1lHVGxXR1FWVWRUdVdDTmErU1cwY1lodzJB?=
 =?utf-8?B?Rnp2d0J2YWRzSlptQXZIb0JWT1VBNk1ScXhyZlVUKzRkdG11bzJOZUh1YXhm?=
 =?utf-8?B?QVlHdUtUZTNZOTg2YTAxL2ozVUVZci92OHZuY2pUdnlTN1psN1dvSnBFWTZi?=
 =?utf-8?B?dE1va0pCTThZLy9CSUtON0ltcWFsdVhJSHFNamhCTzFZbkR0TUdEc0cxYXdz?=
 =?utf-8?B?UHJUYlJoL3FHeDFRZW0wM0tTTGZOYTdZRk5jdmFlTlFBNy9IOEhzWGx1Nm1u?=
 =?utf-8?B?cDVxNkR3dXIyUGVCZzJpRCsyTlV5U2Y4YXhlTG84QVVDTGJRakJQQnVHbVJ4?=
 =?utf-8?B?QVBmRnNsNU50YXJ0VHhFdHVCUExyMTE2WG1od1NDNExUMmR1czdjWnlhdzRm?=
 =?utf-8?B?dzZKL1l6c3pFelVET1oycmZDaTB6YlVrbFkzUURQcnBOQzkwZHh3N1NySGRP?=
 =?utf-8?B?M3RTYUdpZlRhTFZVTWNNQXU4UHdFZjlvKzlZS24vVDRNcVlwYW9ONnltZlBh?=
 =?utf-8?B?a2NEckZLazVyOEtyZ0ZFNTcvR3lHSnFBY3UrMUp2VlFmZUJBK3dPeDZUVEZV?=
 =?utf-8?B?cTk0bERvMGxrVVYrUk1uVHhQcEQ4dkhxdEMvRVNPZU5ncnR3RkhKRlVpMGlN?=
 =?utf-8?Q?K7tyhXC4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 278df4da-d970-4797-d0ab-08dbcc0580a6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:00:20.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mG6a89pNf7qammHlPt4m6KW2RfK/m4dOEYzcsgTqhF+Gaittcm8kw5yqtmUIr+zXYLLzLZhEVdZE6D205EzEfkBWBIzWMM09o61YQy1qqoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130136
X-Proofpoint-GUID: IEXpcElWrdeeqwfilIhWdEzzibrftHV-
X-Proofpoint-ORIG-GUID: IEXpcElWrdeeqwfilIhWdEzzibrftHV-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 16:48, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
>> can't exactly host it given that VFIO dirty tracking can be used without
>> IOMMUFD.
> 
> Hum, this seems strange. Why not just make those VFIO drivers depends
> on iommufd? That seems harmless to me.
>

IF you and Alex are OK with it then I can move to IOMMUFD.

> However, I think the real issue is that iommu drivers need to use this
> API too for their part?
> 

Exactly.

> IMHO would I would like to get to is a part of iommufd that used by
> iommu drivers (and thus built-in) and the current part that is
> modular.
> 
> Basically, I think you should put this in the iommufd directory. Make
> the vfio side kconfig depend on iommufd at this point
> 
> Later when the iommu drivers need it make some
> CONFIG_IOMMUFD_DRIVER_SUPPORT to build another module (that will be
> built in) and make the drivers that need it select it so it becomes
> built in.

That's a good idea; you want me to do this (CONFIG_IOMMUFD_DRIVER_SUPPORT) in
the context of this series, or as a follow-up (assuming I make it depend on
iommufd as you suggested earlier) ?
