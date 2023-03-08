Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEB56B0C34
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjCHPIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjCHPI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:08:27 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962C362D96;
        Wed,  8 Mar 2023 07:08:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuPQzZkqsH+pcWPTcGPYTM07nGe9g2yv8UmB2OXiYX0TS71ZRcLqYX/n74NEJqBrTSz9H9dj0J5Udafeav6i/7nmcNQelqEjsKFlupV0J8m1HzcTDWlrPD7P+cSwyQoTFVkeHmHsomktL+feMOPk7oLm7O2v45JeyxFJY4OVwXHmv3bTquGMIJ1D0d8VcQYHddYVduUULUZ0W96izJ8RUo63Wbr3bnEM85xUleuh7gmd7/2XAphlVv6HX9HL02rfZZqbML4a1YZs8ZYzWXMMxpf8FRngwMP+gmcUEhAnmUSeTPuwE7BGbalG5A3Xuzgyxw7Asb2XPpD+hS8CDX1RVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmuUdoMkzkzdkZwOzixlqJtO5WAMXcENvqxEl/g6Z7k=;
 b=FO4dmh2beQL+03ynn2bmEUewArcchITfu6G8CEFqT08vGt1cIEYLC+eQXtRMsyBd1H74VErsaI1V4qOkNzIOnjWIQnh03rJCMeN5WY2wmuQtKulyQBZ1H8yi0k3w5t2YCRF2+BoFYSzb6Ab5Y18uJQb6po6p37he18VsXjCjtwCXgOsGuFXmGX8EvzfVUHDPKjm8t5vsZZ3ixDXotVN1y6UlvHKcsQkZZvuEZVrhRZeSlAhiFIHsi7ME4qBgaV7BFmJAadzddUrXPZMiMQc827n6Uti4iFiVgYW9Xnoh9dQTSB/4agR/fEhI7cjYi1Q9m6BrMuG14ns9EzJkcx0p6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmuUdoMkzkzdkZwOzixlqJtO5WAMXcENvqxEl/g6Z7k=;
 b=KPGQJgm+TIwEeUYAXwsvCTuEw6Pbqy87fF743xipEFKkTCyNwq6DsKEK1xNSsFzS7z//Og4bn7rO42/rYJl0uTNF/VfCtf/DEH9lUbGyBpcG9RGIYRnAn+JiO0dtPP/x5Mj+2vfkpnQkWjdY9ZvanexBz7hcrdAUEAsNJcXyxXlMo/0pbE4WS/zGzPWoBXPCMrBHFPLLQE+DyPn+reauMpAG/WGLCt8TkG30h0uWAlTgMOet0vVlTcnIgAFcC2615bfFAjDV9bY9QQVsILm3mJaTodLlDKPvd5SJ8oqJf4VlsYw3LzbcfvaEccsS5C2A7Fjie5YrT4/HeA96eVKlSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5354.namprd12.prod.outlook.com (2603:10b6:408:103::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 15:08:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 15:08:19 +0000
Date:   Wed, 8 Mar 2023 11:08:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZAik4NxbNAuJrvSi@nvidia.com>
References: <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
 <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527616204417D92A1BEB5FDA8CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BY3PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5354:EE_
X-MS-Office365-Filtering-Correlation-Id: b22529be-3158-45ad-5704-08db1fe6f383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1aturlci3FLz2ISKhJtvtJ7VazkcqHw/puOWGCChrTLQIGiJNnDNq73X+guQegrWHXv3wHqJb3ZCtJ64ml/SlC/ixOS3ydE+kmzrFVFh3IgLNqnj6LdkgnomD7Ilt0WQA7V+OChRdeU+u2YbXS5YI8JQTaAC7SK0rPEqHkvTOJ4mG6Xe7QTAPyry6ACs+zeHTlMHDN2NbYwG+K5jIHXwSffXav0Ld4OAqRHV/dtykc2njB1tPID053nr8KlV46bwQRQPb/1BhUuSxLHqcU1zlZ1vKF9k6TcPF+h0oaKj9dFNTABtS7BBbGtgGOwnnS6aOzr3M2JFVCl56sd0g9IknMw+ih+pWU92xtKGJkdrZPqudJf/9F2xB4vVDk2DIZLKVBWxwrFgyG8IYQkfNJjsOTSvNaAd04aOZW3q7OdOLu7do34a4oZJkV2JkF97fiBXCTi5lzFKriCM8mrsUO9SUKNr0uLCi6gWYONOdXj4skjKBu/I8l1L7/2OUXktciDAV4UwDaHH0u7PUegsaZ8x2CqrKIFJugE98PzJFbeR49NIYJF9reZGyWcg2EIjaKvx0i8gCRF9KAXugYsYBDCan+loVaY4scLV95q+khkKqDDI8eEjHJrp5wFiryLPAEK0v4RziBbexN+uuEuEzBChpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199018)(316002)(6666004)(4326008)(6916009)(66556008)(8676002)(66946007)(66476007)(6486002)(478600001)(54906003)(83380400001)(36756003)(2906002)(4744005)(186003)(38100700002)(2616005)(26005)(6512007)(6506007)(5660300002)(8936002)(7416002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wDRu1thMJHcXzOS0pLEqp5hKi/2n7rtUPPWUpNkdJ5NPKfD2BFaTX2b11J2k?=
 =?us-ascii?Q?PqZsz12uxXF7dtYW7B3jzyXoSwP+NoZtIoWugk0SHDkj02gma7CcrF07Fm4s?=
 =?us-ascii?Q?k6LiSVAB3tpgsPu+zsLG4SoZpStUhjklZIP2M8IvYUgNGluyLRQvwTWOnvKq?=
 =?us-ascii?Q?nzsnS0ZekYj0sLW2IGjveqfO1NeXJRuDOuBp69dXqSfPFACKoKPEpdhwkBMW?=
 =?us-ascii?Q?5nk8l0LrMZ0CcetG+l0GB1Jv9sn1uEzZKrXBQN4ZuntVDeHZ6Jdk5TUpEppz?=
 =?us-ascii?Q?BEcUpd7iI411GWgNvqoWg0s4vifLTYy6aO3i05IiYw8nGSisjzFroutgYnsP?=
 =?us-ascii?Q?05g5R33EruZHQaozJw+5MrGL+NvDqB3SIKoGQ7ivVi0fAAhvff1xbDlVLb1a?=
 =?us-ascii?Q?xcj9S0PIubove16aGfMGsm5Ogdk6MVkw2T+WwTv2z38oFRIrzpjj3XBnpDBI?=
 =?us-ascii?Q?A6rKPwemdJzyVwXpK/KRkteQtFkbdMc/UAaCm6Zi+0WkcFJk/PkdrAn0r7Mg?=
 =?us-ascii?Q?D3S6y4V/HVAqwpjmhzmovZr9YhD1C3DymykO5fbqPhoOfF88EOFI4+h4YOVs?=
 =?us-ascii?Q?uE6G8M9wWsuOoJw+GcoqvadLsqsns08cKxuE7Dt/PGDqs+SvM0kVai9B9JEY?=
 =?us-ascii?Q?jy19RgXcPjOwsO6cNonm66wlMQ6JP3zqNNnkEVMBsTkbL+E2vH8ctvBqzRn8?=
 =?us-ascii?Q?uzMUv1Z3Peb1sQWm9bEb4eMjPc+bVzRn0WXfbhrTUOEIzDdB97N1lE2mEsfz?=
 =?us-ascii?Q?sK/YTp1oLyUIFNA0bkzfCi2+j0I4OofWTHIbfCybpTFbJECc5hxIJED/GVN8?=
 =?us-ascii?Q?PMffzK0M6jQPDZrNl5aqabSaaVdP38pwF3WsGvl8gvyxdQWgny4/7f/Bgk4X?=
 =?us-ascii?Q?otNnPyYlijMlKnV7HEqEvwiyH45QVa7MTnxxveXPdwOHDSipBBd0e7PbA03K?=
 =?us-ascii?Q?R+5L3jFHY6VTdp/H8shiHOR3Qu8jmVIpLl65wr0mKSmQTzCW3SP5k8xcXTxl?=
 =?us-ascii?Q?kTu6KkZuXD4zLPAVcPAMNWExPKjWjrh2yVK+AEuj0NWuxtBFDQgEW2KwppVz?=
 =?us-ascii?Q?/vexHtCaBNBdSCiDLXd4726EaziKhKvVkx8DJBLTNyEumAAcJ4Xp/RGXIJ4L?=
 =?us-ascii?Q?EIxVeFjTQ2uSo2Q6XOCgqfFb0bggSBEnUdwvfpYvAJT4o4DsdXBotTVjZvz3?=
 =?us-ascii?Q?dMHA7bqe1+8q68Zgzfyg2nlQOBVHEpMG97bocvsyPDO5NZcy/sCg0hbO7Fvo?=
 =?us-ascii?Q?nq32zvJSIh3MWgCuRmJMc7D7ix+FmisP4RwCF34y133XMlci7ks7UNJnp79y?=
 =?us-ascii?Q?mmV9VZ+zJhFC5s4FGkAPRN6KhOBZlI/N89tBzYdaE2V+qetlpKrs8sAXmh48?=
 =?us-ascii?Q?+hOZibBEVEo0e3SA0F3jmwP49LWzhdJM1UuQo86O0XdkpAjztzpXgfgQVdAh?=
 =?us-ascii?Q?s25mF1hTfpVHgRepKEM+I5abVsYdTRB1xV6/dmIB7TsdNj6byhOxIhTLJnzq?=
 =?us-ascii?Q?6kxxPppgXsTNJkxYP8fR9ECpKoz1TCVcXlWo88k94FLziV6oVdQOgx8i6XxE?=
 =?us-ascii?Q?eTlBfPKJNgAdTUquxxRIOWWVcLu42101OKyI78gw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22529be-3158-45ad-5704-08db1fe6f383
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 15:08:19.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i49rYkwq5jGeGY92vAoE+x7msCIFF3c8uC/eNPq3ZhPueWpV0HVzfjpDzKNzHo/K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5354
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 07:26:08AM +0000, Tian, Kevin wrote:
>  * Userspace requests hot reset for the devices it uses.  Due to the
>  * underlying topology, multiple devices can be affected in the reset
>  * while some might be opened by another user. To avoid interference
>  * the calling user must ensure all affected devices, if opened, are
>  * owned by itself.
>  *
>  * The ownership can be proved in three ways:
>  *   - An array of group fds
>  *   - An array of device fds
>  *   - A zero-length array
>  *
>  * In the last case all affected devices which are opened by this user must
>  * have been bound to a same iommufd_ctx.
> 
> and with this change let's rename 'group_fds'  to 'fds'

Looks right

Jason
