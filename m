Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D661F55CB7A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiF0SpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 14:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiF0SpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 14:45:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA338CFA
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO0fmA14x2HCGdEhLL8cmbPJhUy4rh4x7cmSjOQKRCbSLuwB8xsMx05Kx/32QWl+XodvpLePvFVHUh6HnP+9PGKF4qDCdeiOc5f8cZ0nYAyeLsbFLp7JXtXluZd1888aflC/KjQ4j4VwCQWVjDWklJivyCjMF2EK5D7mwy0kIIMBVAAX7FMlDxeFDs3DadtSN96ghG01MoQp35O3fRn93UHZ4YKMztZOK/nfy/M9FcOBHLG4+j2uhWfXGpw6+0QQKDofTGelFCOAw468l1Gcxfl0vz0Db++zvJ8Hi4ntYcd51xdfEBB1cyepczMYtS7x++xSrghT1dUGNafT+2MEKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/5SyGumCFUqPWKlsnbHHpPzR1+NOvZp5vdfbQb16Kc=;
 b=R7k97TZr5vpcmkf8L6dpsbA8X1b6nzRZ5bY3Uyt01B3EKtiNyNCtKq8fU1Mh9Okyirm1Sa7pdD4+rbge5YSRdb07PnP/fgpS2yU9MLt+7EliWF50zNKpG18YulgmgklLgyRctT67jmXYb0ryJ7+aMK7XhfDciPKoRsuLOqQWouswFahKICi6vH2gr7EM5yXfepR1Fu159ICH8bBJ+2GkSOXr4Z7YkCjR2qoMxSG0eVgm052GwtUAKOcxBeOlhahQstxUMoQkVIEiqaG6I0ls4PT6nOypzOI6K0FaRfAGqwSuvAjyjF0aHxT38KuXLMROL2KM+vU8VERsLommzX0DLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/5SyGumCFUqPWKlsnbHHpPzR1+NOvZp5vdfbQb16Kc=;
 b=CPZbzsWMRXsbNUW4QvpQe2xIk+z1/CDwmbZ59NJqe8ERCN3/RZP5WTTRQwrH2i9Y4vL/lsrvLItFDUjcKaHGE0ptD2hjVunDRXt0DsGnapSVkvWkN8WfFCLc0INDgWi6fulekoKxRGWlip9NF4uesgZJA4yVZisxiNCX6CPYDqSU+5sYKVYCvCMqLqtuVuHsI3GwDrRbsHrI1H5aw1fVoFfguuv9oTpubX0LjVhBgHxOcbO4ktO97SHJu4onz1oYIuPzMYFDKmaqWp7Ey+71X0oH3/P8CDbQw9JT5GBv/TAH3mAYORXbh/dbXsZEr7VydDkcgpiXdYJtPycVzd/wMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 18:44:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Mon, 27 Jun 2022
 18:44:59 +0000
Date:   Mon, 27 Jun 2022 15:44:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>
Subject: Re: [PATCH V1 vfio 2/2] vfio: Split migration ops from main device
 ops
Message-ID: <20220627184457.GH4147@nvidia.com>
References: <20220626083958.54175-1-yishaih@nvidia.com>
 <20220626083958.54175-3-yishaih@nvidia.com>
 <BN9PR11MB52767F6751DDCAA7D38734788CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767F6751DDCAA7D38734788CB99@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:207:3d::40) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd17f25b-254e-4ccc-6566-08da586d2311
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ba5AvXheBoUEeLh6IaeR5R2R38l7h8ZeJGEPxdQ1ku8IV1HrE2PsK/HdOHVSuc0FtYpLodtKSlzsSwq+y1iE5QuTzP/ASdREXzEnike/i80dgRrciPcM/dHc2bqO6D3uxoF5qjrXuTNDEhU+C2ckkr0CXyvNikdA3edcemgVEE3pKACeTRG/2trDJodr/hpfwILTJLP0zM0nFrRXktXXVgBxgmK4SCRzclnuPREd3jtli7KXQ/PG96PsqHsZWg1w9+BnCQBioLSBkOBsi7LVPm0H/2axIeDa0m9yn3n3nRcvYUa7zwaHx+dLX6B3HIyVS1S6KToDpOz6meAC3aIlIUYwUj2O1Jgny5mG6h9F+mrbKFTdbNjIbf3HsCG3EAhmKslJ92BSdUKf61yDKkdsbuiuMlU6eKyuarM7wAb/TYTAItqB7LG/SeXe5JSjtoCbezEkGTUEvI1zd+7r4lRoz3Re3JDOtr8+J6SLmfQLLIYsTxErpZpxwvxFZKi97M6/stsmguVjkFFJdqfrH+Xz5A/fep7cDiv95KcLlVeR6ySCWkga6Zu0LIDuOX6oI3YMvN5WnaoZBxIdbmjmugeF2yycLUJefsXE503Yeeg9tjMsC3rR5su5ts/8hXrou5hru4v74N6OG/ixnTqsaXloSYX+LeB/dYgnoHWD39hKvr1UJceG2AGTzEhjdNBcLkenUacIjLWKhLwRGjJRV4lAkwN94GP5m20lxHkAH68Vq0trxSWTRqVwmagCc+ScI9kG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(4326008)(86362001)(38100700002)(6862004)(2906002)(1076003)(186003)(66946007)(54906003)(8936002)(36756003)(6486002)(8676002)(316002)(4744005)(5660300002)(478600001)(41300700001)(26005)(6506007)(2616005)(66556008)(66476007)(6512007)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0bmauisMUaAfbaQdDHqNab93grXljhs8ld28cjftxuPXRB3+BcBkKP0VHKqa?=
 =?us-ascii?Q?GjLXrDCdhN9HjxbP0IDrM0GTvfdlj4FhOoddPfWKo+eVLVIh2GEZW6JnsiHm?=
 =?us-ascii?Q?cg2Tx3gOf8ayUScIjCUPk9wsnwmETBoYyqSqWpJB2UaACvLChmKorqam4Jtd?=
 =?us-ascii?Q?7JM35c9zbkLRA8zsZ0YCMXM2DahbR8Inq+pkh/B45KJR7IJHugqG9zGAwHw+?=
 =?us-ascii?Q?jLcLNAZPNISddrA94walqBnRQJoj3e3/usFLT7pqOAtzdANVdvZb+rFp3drt?=
 =?us-ascii?Q?JR/Ggwv1ahHvrgiGmvGsT3GGiut7wYMrnusYL+tcGvJ9v6VvD5lFrnHraVLK?=
 =?us-ascii?Q?dRYoc60HaC2lJRUiY8ez/x8OljlNlsLS6lfo1LHo50p3V7DLsIdfPwrTQJXK?=
 =?us-ascii?Q?YKpMii0DMtC+6dTAItcJDWwhikNNtZuEk5pcKf3cNQ/6j5g+6uEpLoN9mA2I?=
 =?us-ascii?Q?mcrDeySSEfna7bmsW4GSPT6vurQ5uKpnZhnBxHnjBiQH8E6TQLU7F8MOi2wJ?=
 =?us-ascii?Q?6opvnvWUoh0kOCTUTqlz+nZdQDy9wP1qRRrG7R8Ujm8BYvq2p+Lhv2+kHKNC?=
 =?us-ascii?Q?Uy4GSkV5el4m6TF1Yc8iPWWVRL302sMOPpTzzs5F0OUj8GEwRO5WkiXOQA7F?=
 =?us-ascii?Q?+ZqARe4DK79p0gx/ghO0m3VWKRZKNOlsn9+oXa/UUWtqfItJJEPCN2ty2mzP?=
 =?us-ascii?Q?aNXQlYGxoeH77pLphCejzQLjBa6JqMEjhjxDRfejpx0svM2CANz4sA744CEX?=
 =?us-ascii?Q?rV8o9mUjqBKbjzQtGuuhYq8BhfwCGjCWEft7kpi9n2CcYxPcNtCFHgwWpgF4?=
 =?us-ascii?Q?5FrX2Rao1t2FWOyo3sBhVnqIiCdQgy2cKdvA2Lklo0gH1AknSFFQEoiDxXQZ?=
 =?us-ascii?Q?QhRXwC8tTxveKI5X/+wa71fYXu9sMRVpLFgOzhphUnnuXHDMClxM8isfn3oF?=
 =?us-ascii?Q?JMlxKR8zTyi2r2fk6408OAaYem3PREpNxm+bqQBw8HkBBLVZo9bNEDo1ydRg?=
 =?us-ascii?Q?fgWrCUkxbStTv5otWfeaBvZKMx6WccT9yv5vLfhiuiCsK3yKcfjAUgzfC7ae?=
 =?us-ascii?Q?RF2MPv9c7kYmNm77e0kP6VRilR0t1tjzr5cU+G+9rGR0JfTzxz6PbET0KKFy?=
 =?us-ascii?Q?RHJyHPzVKuJj8u7Y9obvhGivrwSavqOYu5AjHNLPvQivwbaIpJgLp8csWbz6?=
 =?us-ascii?Q?8l4g5qJ2h2BdzaehkIrVV4dJko9Dm++qNEMDysaFIal6WxI0CPe/6+XFwmM/?=
 =?us-ascii?Q?QOFwqBr3XkI4vfvflpoX6jD3umEnMIoKQZk5cieWyGnZT1EEq6pUN0idSAgc?=
 =?us-ascii?Q?7RBSvWrq06Bx7JsVH7X5GvZv+gMA83oTwAaLYOM4vVYS9HxBADzl0N2JadlT?=
 =?us-ascii?Q?hg8RfV/M6GRz5HmZPYzTlX3OMSmMLX00rb/29wqmb9Em/WGr07CxNU/obCld?=
 =?us-ascii?Q?UcREq2RgVoMNZbNQMs+q0DJtv7EMCHPLPeaiYglXmiBBq7FOD1QfJ8aKhKsl?=
 =?us-ascii?Q?UI5rzUKArJvVH/nmSzc4jtoGrV/i/Z+qDHpTsKUZHKbyHsmrR4UxwnYW2Gc3?=
 =?us-ascii?Q?TMh3EyKIANHddjO8dNSMovsC2sM86F24WGONXbMN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd17f25b-254e-4ccc-6566-08da586d2311
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 18:44:59.0930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVG7S2p6NoOh1fTJPFcExstThpjZwuCRYl3O7JYyBPPeD8D9U9GhpvGmruFytZsd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1307
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 07:45:04AM +0000, Tian, Kevin wrote:
> > From: Yishai Hadas <yishaih@nvidia.com>
> > Sent: Sunday, June 26, 2022 4:40 PM
> > @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct
> > vfio_device *device,
> >  	struct file *filp = NULL;
> >  	int ret;
> > 
> > -	if (!device->ops->migration_set_state ||
> > -	    !device->ops->migration_get_state)
> > +	if (!device->mig_ops->migration_set_state ||
> > +	    !device->mig_ops->migration_get_state)
> >  		return -ENOTTY;
> > 
> 
> device->mig_ops could be NULL.
> 
> I still think that it's cleaner to do above check when registering the device
> while leaving only a simple check on mig_ops here and later. While at it
> you can also include check on VFIO_MIGRATION_STOP_COPY since the uAPI
> claims it must be set in migration_flags. All those checks can be done
> once at registration point.

It makes sense, I also prefer validating ops construction on
registration.

Jason
