Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFB46C1B38
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjCTQVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 12:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbjCTQUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 12:20:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ADC9033;
        Mon, 20 Mar 2023 09:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQIPnD8G9q0pWf4L2+ZWP6sCmlGWX59kGWJfBznWfo6hoIma3fx2YNPa5W6piZ6swSrVXRLBWjxZnwGvMax26Dyx17VDgXLi6BwNoDEWrKQKY8wjN2JU6QJrpVL0zRLIxB1V5lnuXaYDGWjUaUR2t48c85pJU6kNHDEVDVgp+FwJu4Ro35HGcVuLu+BN2xmQvzgyX4iVUuDc/M35SNxC49U8OrYuy9gUGIr+iPC3b5sDAjLr4DGChMDzNez7RumXnoqldKtpjgfC+EWm0xjTUOoyUX7Bm3ExhRQLjiT9DGTCYAeyXTcIGzjhjl50P4sdojROMRVMg4jyfyJV6d4lLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SpXa1NsgDkWyMOTwbfTUKeZcVxeJj1Isttqh1+DOWE=;
 b=U67ish+0dewQTpCkzIbzusj8DKmVDP7CEtnrWKdZe1vi+9vjCaWmpn/IObXzidJPK0jVetnDtkythzfBOCZoQA9wrmosuTOHsihDjjbMEAH/cntccY2hQRGyn1eInfRTPM51EHeeedXrEVMAcQYlIYcIN7L+sfi1GtZK8ezaw9iZ6jw1NuLcQ3B4Ne+vZBKrV6/HO8/cOewgzkUzzslAZmBt3X2ampVin+uvZ0cUx6168a4kAnm0HPXKFMWfaSRCeBX7erNLCT5ksF/WUwE2sJSDzC4JP43WbQC2G7OrWmglUV0lrawNKqQznY8U/Zqmj35vPsTqERlKF3CJWaYczA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SpXa1NsgDkWyMOTwbfTUKeZcVxeJj1Isttqh1+DOWE=;
 b=lTji+ua1ZEtn9gl8AWm6x5MwUMmNjMfNICfWE75c7JHBSPQZdL2RElrziPDNj8unCehM3w27zkf0X/fkDCT6dDFCMZp92g3zs/6kokrsNzLqhcklkHW9gV9E8okH0783tL89E6elmFaO2RGscpGcDL7aTggzg63r7590sP03pyt2n9/HN2NGr25FfgRsVdbAGOm4NKuKu0ZUFjAaK4OYbszzLTNn+JN8113bK59Pd0k+FIeL4al9Ktw+pVbDOkMP65uQMRJF/2N6K/kU4PTLJrWKWK6J+cPBS+facLOIVPPRm+HzIuMNSnA2gcTcZ4FF1a/G52orcetGY+9OKKeLwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CYYPR12MB8989.namprd12.prod.outlook.com (2603:10b6:930:c2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:12:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:12:28 +0000
Date:   Mon, 20 Mar 2023 13:12:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Message-ID: <ZBiF6/AkznbXHWbx@nvidia.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <549e6300c0ea011cdce9a2712d49de4efd3a06b7.1678911529.git.reinette.chatre@intel.com>
 <20230317150554.6bf92337.alex.williamson@redhat.com>
 <61296e93-6268-05cd-e876-680e07645a16@intel.com>
 <20230317170149.2be79d5a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317170149.2be79d5a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CYYPR12MB8989:EE_
X-MS-Office365-Filtering-Correlation-Id: b30fafaf-4419-4a20-5022-08db295de6b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0ZH4zqsolyPyqlOxsYohA70hJn+T4u5MViD5uF2T/RqWeletyZgadICED70h8L8Xk8Nt2T4vJlIDbSTgihm2Q+QQAy5G4iHOjQ6Cc/UcnM5d7RFkux6ciNgUHHxOMzncNZREKAW61jOWezEQXI4XrTup9N/+u+uyKZJd+oMlwYgkCfLHBv5gjCIkk2RYOUXnKL++cDleuVfqXZHk4rOd2DrZku/2kVu1mVdGVaaReL9rF+Dg3jgBJYSI4B5DzWYes/5ZFrVlFtqmqMmPX/EdVj7t5VaQxpPHpSJ7naD6sEhTD9oJ73gtxMGCZVvIsVa7PqLIJYSSbnYjIn5fnk1H+3ZTXtzYcVdjpAHWXoEp1XJP+JXXyqYMH+FjE1Ks8IO2CPxLg7H5+ggfxPc2l3Jb86JV/PG+4RW+xGsgBxnw1ScSJiaBKelEx+OoD86Wln/Ti/aYwjXmMYvuNDfI+M68Jk/idLWdAV74leNEHEM0iOvNRhQVQfAwSuqBLFm9TGNuNFXON0WeierJFYze3KJfATCz/kPNrgfJ9Qoq3+opj9zV6G6vSpn+w2BdGcbpDY5FH/kLux7HYlf4zsYNMG5XfTMs94p/plppe3rJntXOPShJOnyXBbOVzMkd3K4wnHvI5SiVX6s2x3GioUphXhvMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(6916009)(4326008)(2906002)(8936002)(41300700001)(7416002)(5660300002)(4744005)(6512007)(8676002)(6506007)(26005)(186003)(2616005)(316002)(66946007)(6486002)(66556008)(478600001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4sOYf7Q4d5L1p0oFhfONRUPRMxDZeVWukSSl0XhtwVZg0BDJpBetveTge96l?=
 =?us-ascii?Q?Lm0vtlPSQ8FGU3YB38m9m8Y95wssbE8ghagPH1H0GG87cMYuI4A2BhQQ8vb/?=
 =?us-ascii?Q?p0VoQ+u+egkoYb5wY847IhePPvvV0DbY2JxoIot3DH1i8Tq4CeZGDsPTsImd?=
 =?us-ascii?Q?y1YD31fzUrhWa93bTyDD86TZ9MC22Lscg/GdfKwhM9vWetMseCfVWkrs/grV?=
 =?us-ascii?Q?boXS91EmaPRzlnF5bTCiZxtZRrdmJq3M2J4/jtzPlPwV64VkW6x0RW4dEJe/?=
 =?us-ascii?Q?sALex0pP9v42heutEUTcOH3F+/jyGyoqYLLwghxNPP93GYxCAwc35jlO7Bux?=
 =?us-ascii?Q?E7pCvYxUQ0MAmwqkXG4VR1CR2007XpQ/jolR9fwj+9dd0gTG0W9gyUDZmWP1?=
 =?us-ascii?Q?r2qygFH5opYZ2R5shFvzzYh3OYXIDb43eBV6Wrf224/BAJEuQv5HGivjwAWO?=
 =?us-ascii?Q?zPw5MKZ9nMk7PhMcMJB+aTNNMZHoG17vX2S195QkLS7kQGtzkCGqPQ+aBQkf?=
 =?us-ascii?Q?kZwNe0WwlS792Jsgch0/HobNfXRxIVOmpn0d+0uOv67UC9lu/0DfteHZYKdq?=
 =?us-ascii?Q?CXrdhL2QfeX1ULoSdgGRcuG0cyJoXwbhtgNZcVZTXeslJsUapAMLS+aF4T4i?=
 =?us-ascii?Q?SQUQ+Nbg9J5xCuYNh05rFpcDm3tB1TNS0tVXilTg5TS3aIn1jfgBI4+GPdpd?=
 =?us-ascii?Q?hGEXn3PAMoMytmQE/saqQxwO6Oys9eBOrWlJkFazLKUTVKYm4zRkfQV8vIyk?=
 =?us-ascii?Q?2O+VyZr/vVO9Pn5r9pTzXFqkGo2vQAG+d91Vy0V/tAiVyCJDaY50sJmdDTfV?=
 =?us-ascii?Q?t62A3LphYO3DEmBmR81HMOxTwKSjMEj8Xnpq7avBI7quBT6z5Vb/eCaEfY9y?=
 =?us-ascii?Q?5KqfxrQbmT7A7cpI0zjq2/0g/bmjJZFEDqJmeN4DrcNzo2/2z9PokOOsVFMz?=
 =?us-ascii?Q?8MtbsTDZSAGcYZ9PufRmdVd0gGizUxcPeMO0ggUkgN1mDKl0QCLDAJxyKy/B?=
 =?us-ascii?Q?I+bB2DjIDT++SSmTx+khm7Qe0wjsGnrITN7/SZvna3CRX1eU+5rEY92lxf77?=
 =?us-ascii?Q?PYRusP2wgeo91dauRZA6K0TnJxxFPm/NetQqby/Lezo5aQq4lu5Q2EQCjCjs?=
 =?us-ascii?Q?bc4CFt6ufnsMDNMx3DFD+zwY6BTloz9U75ubszHdYMJrWzRGXCW6mMKQkH9z?=
 =?us-ascii?Q?h8sQjB5wSSIVr0SUa+22LQemD7fAq0qBf7JC+CCN5lt9Ct2ZPcwRN3A7ByAN?=
 =?us-ascii?Q?bHn3SWaLxLf0bHKW8ZFNrupn0XefVxpfUaCja5+4QPr3FG4UVhRc1fEmDO/r?=
 =?us-ascii?Q?AHcaKTCf4EI+vZDvWeyL6+4OWzv2hLJq5vJFqzhVHLCxIWhBh5Rxdzg34+Ud?=
 =?us-ascii?Q?ePH4MUU74zCSRKgoD0OXuhTFvTgUji01ZRChmCESJJwgsQUIK4Q2F9k0CBKM?=
 =?us-ascii?Q?rXo7DP06VxLdM1WK3n5cNRuz+GtwGirJqOmyY/V8a/19m5C2DZoT1YtzneFS?=
 =?us-ascii?Q?sxjoPpguis3f9NUIsMv+DqMokOjCrIuV0Gsn0nGn6k51UEOqdCHtNjLtWY+J?=
 =?us-ascii?Q?yu3+36RtliReQkM3R3EVaSeKokGA+URuYp6ug2+8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30fafaf-4419-4a20-5022-08db295de6b2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:12:28.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 582u3DKq7ex2lYh54JR+DlkNwvxv7+cGkZ1RQuBOlkX8jFw8nUsWPAFPGnKrdLUD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8989
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 05:01:49PM -0600, Alex Williamson wrote:

> pci_setup_msix_device_domain() says it returns true if:
> 
>  *  True when:
>  *      - The device does not have a MSI parent irq domain associated,
>  *        which keeps the legacy architecture specific and the global
>  *        PCI/MSI domain models working
>  *      - The MSI-X domain exists already
>  *      - The MSI-X domain was successfully allocated
> 
> That first one seems concerning, dynamic allocation only works on irq
> domain configurations.  What does that exclude and do we care about any
> of them for vfio-pci?  

Several archs and other weird things override the MSI-X programming. Eg
by turning it into a hypervisor call or something. These were not
converted to dynamic mode.

So at the VFIO level you can get end up with MSI support but done
through legacy paths that don't support dynamic allocation. Eg on
POWER, xen, etc.

Jason
