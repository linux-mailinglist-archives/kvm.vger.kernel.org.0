Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1557208C4
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbjFBSE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 14:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbjFBSEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 14:04:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47143A3
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 11:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLg4WrSI/A6rEC4IqJtJTCS8j0CfE8IpYRWwwXFG8YuRqDo5zvKpRPfjawW42lgEryJfTdVgdjrCTkcMaLDOjVO6oSNF5YtomhN3esPQagBWgKdbYTQgZefvuvD46dcUo9LdzwduPWtnyyFmL3n/WPOTr9sDklPBdyNpKLNtCE3NjcoaleQYH8sKMbbmwrH14i5MK5S8K2b4WMBMr9ge2p2yHfkqa3qn/0UJg0m1skmT0w9BXpvx87x/A58AlpC5fQllxjuyyRDGONlT2tBRYcSJtA8AyvG9XGh9JYajLdOqHk1Lp7gytx/I4iJfxGUAtTsZoh30Lh9KgN7jbObd3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsC5no6pRIy2KHHbZ4f0+o2SNl011p98htIEg87BX7k=;
 b=hrxbuJxYw2T/J1GkwkT6Ql3QUpoXit3r9661L5f/n9WZKvyxjO4o+boXFJb9blB7+iJHRf5gNlEO0IFT5Af//VNo/waBK2eYz8tj+le3CEKNbB253sgbWzx6YqQExTYHVAXNUp4iNoERS9KJNH55aDFp7V/nb3VQ+Knsr4emapXoJil/4gyiasCtLrLu5yfYcHFH/gYGCWfEqkd2V5UcXVamdBwKKCDH2iX56Ud0cSMVcQYtm+PvN9N2v9AFzv96OihJt9biWEmJ2if59Yhe72MKgp5Hm+QdnKGICtqInVeopMKfdPm3bCPtCeeugANz854eTh+q+8s6fDdVc3XoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsC5no6pRIy2KHHbZ4f0+o2SNl011p98htIEg87BX7k=;
 b=Se1ShQZTfqpqvStkPRGJIY+JTRc1T2w+whBL2n6/gxF713ehRe3FUyM0Whsz0AVMAsMWjb8ZtdSe70+qgLjWsFqV+8IVOg+JjHlv5XGD0VcwOI4ZZvhArVYrxMRPljLDs8UUQXGKPoyQyPGKa9ActLBFRgsrnxvl5Sqj4O1Og/4=
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by IA1PR12MB7710.namprd12.prod.outlook.com (2603:10b6:208:422::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Fri, 2 Jun
 2023 18:04:45 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::8342:8674:c982:305a]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::8342:8674:c982:305a%5]) with mapi id 15.20.6433.024; Fri, 2 Jun 2023
 18:04:45 +0000
From:   "Giani, Dhaval" <Dhaval.Giani@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        "steffen.eiden@ibm.com" <steffen.eiden@ibm.com>,
        "yilun.xu@intel.com" <yilun.xu@intel.com>,
        Suzuki K P <suzuki.kp@gmail.com>,
        "Powell, Jeremy" <Jeremy.Powell@amd.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "atishp04@gmail.com" <atishp04@gmail.com>
CC:     "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: KVM Forum BoF on I/O + secure virtualization
Thread-Topic: KVM Forum BoF on I/O + secure virtualization
Thread-Index: AQHZcpVEhdygIUw+9E6qtbQ593vuva94Ex9U
Date:   Fri, 2 Jun 2023 18:04:45 +0000
Message-ID: <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
In-Reply-To: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=True;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-06-02T18:04:44.616Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|IA1PR12MB7710:EE_
x-ms-office365-filtering-correlation-id: 6112e88a-8e3e-463c-2869-08db6393d911
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8/VB3MB4/Tu8uhnCqC7tHI7hm/BglNJ22iQsJdMGKqURKk7C+kE5WofxXdYj0XEWojwOLPe8tvGGEi43kzxvncF6AfCnEpMu7Y7vayLJPZz2eoww3d6xa4Ghz4iFL8PLgAeWmqy/se4Xu0VKsf+E539zOK73QX3+Zn3C8JQCBACd7KC5m7nGSLNKLEO4BdJa17W4MfM9Pn7ffHHI08FgHoNJ8H4qjCbFDfPngjamnleikbixzFoYzq6GrBNzzUUyF+pHwlrn6FjUMOMsULD4OczbtShLMKe2aO9eiuHUH1DfrJgQdOm0LaJLkW5DFugFiV6b+o6KBxQcNjgH4JTNERfXm0uZmhNMLKKq+tvSDWgrNUATjMMxnGFDQ/bxtx39VopJbvOGv0Q635T1h0zckrcNOSK2AfgByucXKfDAPr/yF4LGd6AHV2lYCfoAoEIrMY8+GE20oK48shHZLdIB8hTjNRjNnP23I1aruzzoVrsaJYZEZxbVMWKVoHXm+MwlUAxZF8GV4Ne6VcbjvJD20Kr9qwa07m4jcD1d5W/XiZULUo/sIwPuYbvWLXpVHEmcaR6Ks+xhuUa5IukBTGsv5DQd4jJCIHQyNKKSaitWfhEahcabfMa0Wqu6BzbVHaRZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199021)(921005)(122000001)(38100700002)(86362001)(38070700005)(33656002)(8936002)(41300700001)(55016003)(8676002)(966005)(26005)(9686003)(52536014)(6506007)(5660300002)(2906002)(186003)(76116006)(66946007)(91956017)(66446008)(7696005)(316002)(54906003)(66556008)(478600001)(110136005)(66476007)(71200400001)(4326008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?nMlvcwl7feKzw0+Dm/7STZ/yZ5OlNn1lJJeQnyzw1p8I7/PyLdRELfaD?=
 =?Windows-1252?Q?BjWR4rHNEXl14+5KKqvB3R3kKsMczbrfubvInTPRn3rdDUmaXPRoYuUN?=
 =?Windows-1252?Q?MSeZ83yNepmniU6m8hg7TgG4TvaQRYv5y+SM35jxF/ZRO8yNYzb5FHc4?=
 =?Windows-1252?Q?og4sfBY9UTNcaEecYcxF9q6LJKDwE4j2HZT1gwJ1HIfT88dk1IpnlGrG?=
 =?Windows-1252?Q?5AJXcd6Xoato1zCu4N3PXAH+uuyO18TOHLrVtCU5OV9dxaapbEs0jUzd?=
 =?Windows-1252?Q?QAzAHSikVjqoOz3NldDzm8MEC57EJjkOSbjQdyUNKGJm57AMSTT13nlN?=
 =?Windows-1252?Q?yfL/y2M0JWAl47ClJrxMA8hdAfjyzVSMRXQAlnm4zGJ0yeFJYe9A31j4?=
 =?Windows-1252?Q?iGnRaC2zWW0Yf3GedQqAFL4aHTlzcOih68LTDlX7LX5dhxoX8Q5uFa2J?=
 =?Windows-1252?Q?cQ891pJz1eB5td5FUYCDzbOPT8CcAD/zpdqE/nMohWv8TitKfvP0Mn1m?=
 =?Windows-1252?Q?na0pspP5CpIeyL7Hvy0iE18eLv4vGVhhMWtI5OkEO6pTD6IzC1cn74Ry?=
 =?Windows-1252?Q?h9D4HuCYuV1wqwFDQTqY3MS1DbKD2witZmFot0WmEf3bZf3JiCWO+3tx?=
 =?Windows-1252?Q?YelMwjRi8W+OYF8iRxe6f9lyLEUpmQo4B4P3YeNbuGT5dLLVg7mxdEm4?=
 =?Windows-1252?Q?XSHQtMIn1fb7+v+40xHb9nwBhvXr0KaolhhWSj7Z5ld2nXnJ/0fa6cpl?=
 =?Windows-1252?Q?wJjSuTfN6VS6S9DhcmYJhaDszE/FAn/v2Iod91l97YPsqr/MkUS7Lq36?=
 =?Windows-1252?Q?idSFgdr4UQZn3OkgVbxxfh2w84mwWzZuYae8z1049uEUExPeS6KoQBEi?=
 =?Windows-1252?Q?66C2lbOJfNtd5qx07G4rfzaBURo89+zoNe9Z6WXNCCtSSCMWqijzNXXp?=
 =?Windows-1252?Q?owqfB++1HcGswa88q+0WUKcwJ2A+vJYF04xy+zSlOFxUR4N57rkCUsbr?=
 =?Windows-1252?Q?o7SzXOYSYQjE7t8pSbfQIn29CziIg6qlsdIIGzmH96AyFCbk7xDcdZ5J?=
 =?Windows-1252?Q?4xNTQdkKXZ95nt+fKflTBfe5uxuM75AiHW8vlNu+LwkrGNhZ35g0nZgV?=
 =?Windows-1252?Q?y/QR4Q6LQdpN4oX5Y/1pSL96rQTHoz4I52f8AtApk3Si2k59y62lfWFS?=
 =?Windows-1252?Q?HyL1Zo6pKfuUoqYFjEUKJxOPsbFFkzgvUQ/rSSTp2LYtCL3XTt6mP9sh?=
 =?Windows-1252?Q?YqQv+JBW/0XFZPKsDoZFtw/Ev/MSpYiORhY/3j0GVwzG0wuIQpjy+/ak?=
 =?Windows-1252?Q?vcQR4AEp1YZhBCvq7RCKzf/GvkaU581yeaR9KIq+9Aoxy7vMQrg6pAKi?=
 =?Windows-1252?Q?o07iixwxujvBYgbt10kZtyccbmq/jWJzVplNo0BFH3JCj0GNrAe4NmHd?=
 =?Windows-1252?Q?HezjJN+9CPrqGA2r0oH9YuG/hTCnouiFrgdE2jpK2SK+IQX0xKQwvFS0?=
 =?Windows-1252?Q?18pcoEc+vrXnqiI+jwu0Tv2EG1Er0JCrJw//Gs9aY7YC48zenklDuwOy?=
 =?Windows-1252?Q?WBHG5JYL+40uxRKv1xZrwgUdvmGh5YwlX9K7w3/2M1sAf0lZcB79teUa?=
 =?Windows-1252?Q?R3NOaUDa0qwIl3TUn6Yay8p7RtwODj6MiRH5pfvouoI+GlAMNfABom2w?=
 =?Windows-1252?Q?ui9kNz3fULs=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6112e88a-8e3e-463c-2869-08db6393d911
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 18:04:45.5941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iapyzEnagb/HHldw4547hC8lyjh9d1ne6EL5z5YlJSmixZPgGR9n9qCdewdlhFg73zKND8qcg6TBgwJnjeADOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7710
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hi all,

We have proposed a trusted I/O BoF session at KVM forum this year. I wanted=
 to kick off the discussion to maximize the 25 mins we have.

By trusted I/O, I mean using TDISP to have =93trusted=94 communications wit=
h a device using something like AMD SEV-TIO [1] or Intel=92s TDX connect [2=
].

Some topics we would like to discuss are
o What is the device model like?
o Do we enlighten the PCI subsystem?
o Do we enlighten device drivers?
o What does the guest need to know from the device?
o How does the attestation workflow work?
o Generic vs vendor specific TSMs

Some of these topics may be better suited for LPC, however we want to get t=
he discussion going from the KVM perspective and continue wider discussions=
 at LPC.

If there are other topics you think we should discuss, please let us know.

Thanks!

Dhaval

[1] https://www.amd.com/system/files/documents/sev-tio-whitepaper.pdf
[2] https://cdrdv2-public.intel.com/773614/intel-tdx-connect-architecture-s=
pecification.pdf
